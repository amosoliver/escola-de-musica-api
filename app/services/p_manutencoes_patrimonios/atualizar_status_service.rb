# frozen_string_literal: true

module PManutencoesPatrimonios
  # Transicao simples de status (SOLICITADA -> APROVADA -> AGENDADA -> EM_ANDAMENTO,
  # ou CANCELADA a qualquer momento antes da conclusao). A conclusao tem regras
  # proprias e e' tratada por ConcluirService.
  class AtualizarStatusService
    def self.call(p_manutencao_patrimonio:, novo_status_codigo:, attributes: {})
      new(p_manutencao_patrimonio:, novo_status_codigo:, attributes:).call
    end

    def initialize(p_manutencao_patrimonio:, novo_status_codigo:, attributes:)
      @p_manutencao_patrimonio = p_manutencao_patrimonio
      @novo_status_codigo = novo_status_codigo
      @attributes = attributes
    end

    def call
      return manutencao_finalizada if p_manutencao_patrimonio.p_status_manutencao_patrimonio.finalizador?

      novo_status = PStatusManutencaoPatrimonio.find_by(codigo: novo_status_codigo)
      return status_nao_configurado if novo_status.blank?

      resultado = nil
      ApplicationRecord.transaction do
        unless p_manutencao_patrimonio.update(attributes.merge(p_status_manutencao_patrimonio: novo_status))
          resultado = falha(p_manutencao_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        next unless novo_status_codigo == "CANCELADA" && !p_manutencao_patrimonio.externa?

        situacao_disponivel = PSituacaoPatrimonio.find_by(codigo: "DISPONIVEL")
        if situacao_disponivel.present? && !p_manutencao_patrimonio.p_patrimonio.update(p_situacao_patrimonio: situacao_disponivel)
          resultado = falha(p_manutencao_patrimonio.p_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(p_manutencao_patrimonio, HttpStatus::OK, "Manutencao atualizada com sucesso")
    end

    private

    attr_reader :p_manutencao_patrimonio, :novo_status_codigo, :attributes

    def manutencao_finalizada
      Result.failure([ "Manutencao ja finalizada, nao e possivel alterar o status" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar a manutencao")
    end

    def status_nao_configurado
      Result.failure([ "Status #{novo_status_codigo} nao configurado" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar a manutencao")
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar a manutencao")
    end
  end
end
