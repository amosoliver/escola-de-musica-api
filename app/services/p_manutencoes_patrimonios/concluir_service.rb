# frozen_string_literal: true

module PManutencoesPatrimonios
  # Conclui a manutencao. Se era externa, registra a movimentacao de retorno
  # (RETORNO_MANUTENCAO) de volta ao ambiente de origem do patrimonio. Em
  # qualquer caso o patrimonio volta a DISPONIVEL.
  class ConcluirService
    def self.call(p_manutencao_patrimonio:, params:)
      new(p_manutencao_patrimonio:, params:).call
    end

    def initialize(p_manutencao_patrimonio:, params:)
      @p_manutencao_patrimonio = p_manutencao_patrimonio
      @params = params
    end

    def call
      return manutencao_finalizada if p_manutencao_patrimonio.p_status_manutencao_patrimonio.finalizador?

      status_concluida = PStatusManutencaoPatrimonio.find_by(codigo: "CONCLUIDA")
      situacao_disponivel = PSituacaoPatrimonio.find_by(codigo: "DISPONIVEL")
      return referenciais_ausentes if status_concluida.blank? || situacao_disponivel.blank?

      resultado = nil
      p_patrimonio = p_manutencao_patrimonio.p_patrimonio

      ApplicationRecord.transaction do
        unless p_manutencao_patrimonio.update(
          p_status_manutencao_patrimonio: status_concluida,
          data_conclusao: params[:data_conclusao] || Time.current,
          descricao_servico: params[:descricao_servico],
          valor_realizado: params[:valor_realizado]
        )
          resultado = falha(p_manutencao_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        if p_manutencao_patrimonio.externa?
          tipo_retorno = PTipoMovimentacaoPatrimonio.find_by(codigo: "RETORNO_MANUTENCAO")
          movimentacao = PMovimentacaoPatrimonio.new(
            p_patrimonio: p_patrimonio,
            p_tipo_movimentacao_patrimonio: tipo_retorno,
            g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
            i_ambiente_predial_destino_id: p_patrimonio.i_ambiente_predial_id,
            r_funcionario_id: params[:r_funcionario_id],
            motivo: "Retorno de manutencao externa"
          )
          unless movimentacao.save
            resultado = falha(movimentacao.errors.full_messages)
            raise ActiveRecord::Rollback
          end
        end

        unless p_patrimonio.update(p_situacao_patrimonio: situacao_disponivel)
          resultado = falha(p_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(p_manutencao_patrimonio, HttpStatus::OK, "Manutencao concluida com sucesso")
    end

    private

    attr_reader :p_manutencao_patrimonio, :params

    def manutencao_finalizada
      Result.failure([ "Manutencao ja finalizada" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel concluir a manutencao")
    end

    def referenciais_ausentes
      Result.failure([ "Referenciais de status/situacao nao configurados" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel concluir a manutencao")
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel concluir a manutencao")
    end
  end
end
