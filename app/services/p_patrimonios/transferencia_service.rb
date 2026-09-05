# frozen_string_literal: true

module PPatrimonios
  # Transferencia interna: move o patrimonio de um ambiente predial para outro,
  # registrando o historico em p_movimentacoes_patrimonios e atualizando o
  # ambiente atual do patrimonio.
  class TransferenciaService
    def self.call(p_patrimonio:, params:)
      new(p_patrimonio:, params:).call
    end

    def initialize(p_patrimonio:, params:)
      @p_patrimonio = p_patrimonio
      @params = params
    end

    def call
      return situacao_invalida unless p_patrimonio.p_situacao_patrimonio.permite_movimentacao?

      tipo_movimentacao = PTipoMovimentacaoPatrimonio.find_by(codigo: "TRANSFERENCIA_INTERNA")
      return tipo_nao_configurado if tipo_movimentacao.blank?

      resultado = nil
      ApplicationRecord.transaction do
        movimentacao = PMovimentacaoPatrimonio.new(
          p_patrimonio: p_patrimonio,
          p_tipo_movimentacao_patrimonio: tipo_movimentacao,
          g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
          i_ambiente_predial_origem_id: p_patrimonio.i_ambiente_predial_id,
          i_ambiente_predial_destino_id: params[:i_ambiente_predial_destino_id],
          r_funcionario_id: params[:r_funcionario_id],
          motivo: params[:motivo],
          observacao: params[:observacao]
        )

        unless movimentacao.save
          resultado = falha(movimentacao.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        unless p_patrimonio.update(i_ambiente_predial_id: params[:i_ambiente_predial_destino_id])
          resultado = falha(p_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(p_patrimonio, HttpStatus::OK, "Patrimonio transferido com sucesso")
    end

    private

    attr_reader :p_patrimonio, :params

    def situacao_invalida
      Result.failure(
        [ "A situacao atual do patrimonio nao permite movimentacao" ],
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel transferir o patrimonio"
      )
    end

    def tipo_nao_configurado
      Result.failure(
        [ "Tipo de movimentacao TRANSFERENCIA_INTERNA nao configurado" ],
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel transferir o patrimonio"
      )
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel transferir o patrimonio")
    end
  end
end
