# frozen_string_literal: true

module PManutencoesPatrimonios
  # Abre uma solicitacao de manutencao para o patrimonio. Quando um destino
  # externo e informado (oficina/assistencia), registra tambem a movimentacao
  # MANUTENCAO_EXTERNA. Em ambos os casos o patrimonio passa para EM_MANUTENCAO.
  class CreateService
    def self.call(p_patrimonio:, params:)
      new(p_patrimonio:, params:).call
    end

    def initialize(p_patrimonio:, params:)
      @p_patrimonio = p_patrimonio
      @params = params
    end

    def call
      status_solicitada = PStatusManutencaoPatrimonio.find_by(codigo: "SOLICITADA")
      situacao_em_manutencao = PSituacaoPatrimonio.find_by(codigo: "EM_MANUTENCAO")
      return referenciais_ausentes if status_solicitada.blank? || situacao_em_manutencao.blank?

      resultado = nil
      manutencao = nil

      ApplicationRecord.transaction do
        destino_externo = nil
        if params[:p_destino_externo_id].present? || params[:p_destino_externo_attributes].present?
          destino_result = PDestinosExternos::ResolverService.call(
            g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
            p_destino_externo_id: params[:p_destino_externo_id],
            p_destino_externo_attributes: params[:p_destino_externo_attributes]
          )
          if destino_result.failure?
            resultado = destino_result
            raise ActiveRecord::Rollback
          end
          destino_externo = destino_result.value
        end

        manutencao = PManutencaoPatrimonio.new(
          p_patrimonio: p_patrimonio,
          p_tipo_manutencao_patrimonio_id: params[:p_tipo_manutencao_patrimonio_id],
          p_status_manutencao_patrimonio: status_solicitada,
          g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
          p_destino_externo: destino_externo,
          r_funcionario_solicitante_id: params[:r_funcionario_solicitante_id],
          descricao_problema: params[:descricao_problema],
          data_prevista: params[:data_prevista],
          valor_estimado: params[:valor_estimado],
          observacao: params[:observacao]
        )
        unless manutencao.save
          resultado = falha(manutencao.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        if destino_externo.present?
          tipo_movimentacao = PTipoMovimentacaoPatrimonio.find_by(codigo: "MANUTENCAO_EXTERNA")
          movimentacao = PMovimentacaoPatrimonio.new(
            p_patrimonio: p_patrimonio,
            p_tipo_movimentacao_patrimonio: tipo_movimentacao,
            g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
            i_ambiente_predial_origem_id: p_patrimonio.i_ambiente_predial_id,
            p_destino_externo: destino_externo,
            r_funcionario_id: params[:r_funcionario_solicitante_id],
            motivo: "Envio para manutencao externa"
          )
          unless movimentacao.save
            resultado = falha(movimentacao.errors.full_messages)
            raise ActiveRecord::Rollback
          end
        end

        unless p_patrimonio.update(p_situacao_patrimonio: situacao_em_manutencao)
          resultado = falha(p_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(manutencao, HttpStatus::CREATED, "Manutencao solicitada com sucesso")
    end

    private

    attr_reader :p_patrimonio, :params

    def referenciais_ausentes
      Result.failure([ "Referenciais de status/situacao de manutencao nao configurados" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel solicitar a manutencao")
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel solicitar a manutencao")
    end
  end
end
