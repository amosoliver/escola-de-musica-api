# frozen_string_literal: true

module PPatrimoniosResponsaveis
  # Define o responsavel administrativo do patrimonio. Quando o novo vinculo e'
  # principal, encerra o vinculo principal ativo anterior (data_fim = hoje)
  # antes de criar o novo, preservando o historico.
  class CreateService
    def self.call(p_patrimonio:, params:)
      new(p_patrimonio:, params:).call
    end

    def initialize(p_patrimonio:, params:)
      @p_patrimonio = p_patrimonio
      @params = params
    end

    def call
      principal = params.fetch(:principal, true)
      novo = nil
      resultado = nil

      ApplicationRecord.transaction do
        if principal
          anterior = p_patrimonio.p_patrimonios_responsaveis.find_by(principal: true, ativo: true)
          if anterior.present? && !anterior.update(ativo: false, data_fim: Date.current)
            resultado = falha(anterior.errors.full_messages)
            raise ActiveRecord::Rollback
          end
        end

        novo = p_patrimonio.p_patrimonios_responsaveis.new(
          g_pessoa_id: params[:g_pessoa_id],
          data_inicio: params[:data_inicio] || Date.current,
          observacao: params[:observacao],
          principal: principal,
          ativo: true
        )
        unless novo.save
          resultado = falha(novo.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(novo, HttpStatus::CREATED, "Responsavel definido com sucesso")
    end

    private

    attr_reader :p_patrimonio, :params

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel definir o responsavel")
    end
  end
end
