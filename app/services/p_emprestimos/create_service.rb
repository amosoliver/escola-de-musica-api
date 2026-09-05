# frozen_string_literal: true

module PEmprestimos
  # Abre um emprestimo com um ou mais patrimonios (p_emprestimos_itens_attributes).
  # Cada patrimonio precisa estar numa situacao que permita emprestimo (DISPONIVEL).
  # Ao final, os patrimonios envolvidos passam para EMPRESTADO.
  class CreateService
    def self.call(g_unidade_gestora_id:, params:)
      new(g_unidade_gestora_id:, params:).call
    end

    def initialize(g_unidade_gestora_id:, params:)
      @g_unidade_gestora_id = g_unidade_gestora_id
      @params = params
    end

    def call
      itens_attributes = Array(params[:p_emprestimos_itens_attributes])
      return sem_itens if itens_attributes.blank?

      status_aberto = PStatusEmprestimoPatrimonio.find_by(codigo: "ABERTO")
      situacao_emprestado = PSituacaoPatrimonio.find_by(codigo: "EMPRESTADO")
      return referenciais_ausentes if status_aberto.blank? || situacao_emprestado.blank?

      resultado = nil
      emprestimo = nil

      ApplicationRecord.transaction do
        patrimonios = []

        itens_attributes.each do |item_attributes|
          p_patrimonio = PPatrimonio.where(g_unidade_gestora_id: g_unidade_gestora_id).find_by(id: item_attributes[:p_patrimonio_id])
          if p_patrimonio.blank?
            resultado = falha([ "Patrimonio #{item_attributes[:p_patrimonio_id]} nao encontrado" ])
            raise ActiveRecord::Rollback
          end
          unless p_patrimonio.p_situacao_patrimonio.permite_emprestimo?
            resultado = falha([ "Patrimonio #{p_patrimonio.codigo_patrimonial} nao esta disponivel para emprestimo" ])
            raise ActiveRecord::Rollback
          end

          patrimonios << p_patrimonio
        end

        emprestimo = PEmprestimo.new(
          g_unidade_gestora_id: g_unidade_gestora_id,
          g_pessoa_id: params[:g_pessoa_id],
          r_funcionario_entrega_id: params[:r_funcionario_entrega_id],
          p_status_emprestimo_patrimonio: status_aberto,
          numero_emprestimo: params[:numero_emprestimo].presence || gerar_numero_emprestimo,
          data_emprestimo: params[:data_emprestimo] || Time.current,
          data_prevista_devolucao: params[:data_prevista_devolucao],
          observacao: params[:observacao]
        )

        itens_attributes.each_with_index do |item_attributes, index|
          emprestimo.p_emprestimos_itens.build(
            p_patrimonio: patrimonios[index],
            p_estado_conservacao_patrimonio_id: item_attributes[:p_estado_conservacao_patrimonio_id],
            observacao_entrega: item_attributes[:observacao_entrega]
          )
        end

        unless emprestimo.save
          resultado = falha(emprestimo.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        patrimonios.each do |p_patrimonio|
          next if p_patrimonio.update(p_situacao_patrimonio: situacao_emprestado)

          resultado = falha(p_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(emprestimo, HttpStatus::CREATED, "Emprestimo registrado com sucesso")
    end

    private

    attr_reader :g_unidade_gestora_id, :params

    def gerar_numero_emprestimo
      "EMP#{Time.current.strftime('%Y%m%d%H%M%S')}"
    end

    def sem_itens
      Result.failure([ "Informe ao menos um patrimonio em p_emprestimos_itens_attributes" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar o emprestimo")
    end

    def referenciais_ausentes
      Result.failure([ "Referenciais de status/situacao de emprestimo nao configurados" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar o emprestimo")
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar o emprestimo")
    end
  end
end
