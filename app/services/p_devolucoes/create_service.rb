# frozen_string_literal: true

module PDevolucoes
  # Registra a devolucao de um ou mais itens de um emprestimo
  # (p_devolucoes_itens_attributes). Cada patrimonio devolvido volta para
  # DISPONIVEL, mesmo quando ha avaria registrada (descricao_avaria) -- abrir
  # uma manutencao a partir da avaria e uma acao manual separada, feita depois
  # pelo endpoint de manutencao. Ao final, recalcula o status do emprestimo:
  # DEVOLVIDO quando todos os itens ja foram devolvidos, ou
  # PARCIALMENTE_DEVOLVIDO caso ainda faltem itens.
  class CreateService
    def self.call(p_emprestimo:, params:)
      new(p_emprestimo:, params:).call
    end

    def initialize(p_emprestimo:, params:)
      @p_emprestimo = p_emprestimo
      @params = params
    end

    def call
      itens_attributes = Array(params[:p_devolucoes_itens_attributes])
      return sem_itens if itens_attributes.blank?

      situacao_disponivel = PSituacaoPatrimonio.find_by(codigo: "DISPONIVEL")
      return referenciais_ausentes if situacao_disponivel.blank?

      resultado = nil
      devolucao = nil

      ApplicationRecord.transaction do
        devolucao = PDevolucao.new(
          g_unidade_gestora_id: p_emprestimo.g_unidade_gestora_id,
          p_emprestimo: p_emprestimo,
          r_funcionario_recebimento_id: params[:r_funcionario_recebimento_id],
          data_devolucao: params[:data_devolucao] || Time.current,
          observacao: params[:observacao]
        )

        itens_attributes.each do |item_attributes|
          emprestimo_item = p_emprestimo.p_emprestimos_itens.find_by(id: item_attributes[:p_emprestimo_item_id])
          if emprestimo_item.blank?
            resultado = falha([ "Item de emprestimo #{item_attributes[:p_emprestimo_item_id]} nao pertence a este emprestimo" ])
            raise ActiveRecord::Rollback
          end
          if emprestimo_item.devolvido?
            resultado = falha([ "Item de emprestimo #{item_attributes[:p_emprestimo_item_id]} ja foi devolvido" ])
            raise ActiveRecord::Rollback
          end

          devolucao.p_devolucoes_itens.build(
            p_emprestimo_item: emprestimo_item,
            p_estado_conservacao_patrimonio_id: item_attributes[:p_estado_conservacao_patrimonio_id],
            possui_avaria: item_attributes[:possui_avaria] || false,
            descricao_avaria: item_attributes[:descricao_avaria],
            observacao: item_attributes[:observacao]
          )
        end

        unless devolucao.save
          resultado = falha(devolucao.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        devolucao.p_devolucoes_itens.each do |devolucao_item|
          p_patrimonio = devolucao_item.p_emprestimo_item.p_patrimonio
          next if p_patrimonio.update(p_situacao_patrimonio: situacao_disponivel)

          resultado = falha(p_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        unless atualizar_status_emprestimo
          resultado = falha(p_emprestimo.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(devolucao, HttpStatus::CREATED, "Devolucao registrada com sucesso")
    end

    private

    attr_reader :p_emprestimo, :params

    def atualizar_status_emprestimo
      p_emprestimo.reload
      codigo = p_emprestimo.p_emprestimos_itens.all?(&:devolvido?) ? "DEVOLVIDO" : "PARCIALMENTE_DEVOLVIDO"
      novo_status = PStatusEmprestimoPatrimonio.find_by(codigo: codigo)
      return true if novo_status.blank?

      p_emprestimo.update(p_status_emprestimo_patrimonio: novo_status)
    end

    def sem_itens
      Result.failure([ "Informe ao menos um item em p_devolucoes_itens_attributes" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar a devolucao")
    end

    def referenciais_ausentes
      Result.failure([ "Referencial de situacao DISPONIVEL nao configurado" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar a devolucao")
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar a devolucao")
    end
  end
end
