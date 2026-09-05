# frozen_string_literal: true

module PPatrimonios
  # Saida definitiva do patrimonio (venda, doacao ou descarte): resolve o destino
  # externo, registra a movimentacao, abre a baixa e marca o patrimonio como
  # BAIXADO. Reaproveitado pelos endpoints especificos vender/doar/descartar.
  class SaidaDefinitivaService
    def self.call(p_patrimonio:, params:, tipo_movimentacao_codigo:, tipo_baixa_codigo:)
      new(p_patrimonio:, params:, tipo_movimentacao_codigo:, tipo_baixa_codigo:).call
    end

    def initialize(p_patrimonio:, params:, tipo_movimentacao_codigo:, tipo_baixa_codigo:)
      @p_patrimonio = p_patrimonio
      @params = params
      @tipo_movimentacao_codigo = tipo_movimentacao_codigo
      @tipo_baixa_codigo = tipo_baixa_codigo
    end

    def call
      return ja_baixado if p_patrimonio.p_baixa_patrimonio.present?

      tipo_movimentacao = PTipoMovimentacaoPatrimonio.find_by(codigo: tipo_movimentacao_codigo)
      tipo_baixa = PTipoBaixaPatrimonio.find_by(codigo: tipo_baixa_codigo)
      situacao_baixado = PSituacaoPatrimonio.find_by(codigo: "BAIXADO")
      return tipo_nao_configurado if tipo_movimentacao.blank? || tipo_baixa.blank? || situacao_baixado.blank?

      resultado = nil
      baixa = nil

      ApplicationRecord.transaction do
        destino_result = PDestinosExternos::ResolverService.call(
          g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
          p_destino_externo_id: params[:p_destino_externo_id],
          p_destino_externo_attributes: params[:p_destino_externo_attributes]
        )
        if destino_result.failure? || destino_result.value.blank?
          resultado = destino_result.failure? ? destino_result : destino_obrigatorio
          raise ActiveRecord::Rollback
        end
        destino_externo = destino_result.value

        movimentacao = PMovimentacaoPatrimonio.new(
          p_patrimonio: p_patrimonio,
          p_tipo_movimentacao_patrimonio: tipo_movimentacao,
          g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
          i_ambiente_predial_origem_id: p_patrimonio.i_ambiente_predial_id,
          p_destino_externo: destino_externo,
          r_funcionario_id: params[:r_funcionario_id],
          motivo: params[:motivo]
        )
        unless movimentacao.save
          resultado = falha(movimentacao.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        baixa = PBaixaPatrimonio.new(
          p_patrimonio: p_patrimonio,
          p_tipo_baixa_patrimonio: tipo_baixa,
          g_unidade_gestora_id: p_patrimonio.g_unidade_gestora_id,
          p_destino_externo: destino_externo,
          p_movimentacao_patrimonio: movimentacao,
          r_funcionario_id: params[:r_funcionario_id],
          data_baixa: params[:data_baixa] || Time.current,
          valor: params[:valor],
          documento: params[:documento],
          numero_documento: params[:numero_documento],
          justificativa: params[:justificativa],
          observacao: params[:observacao]
        )
        unless baixa.save
          resultado = falha(baixa.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        unless p_patrimonio.update(p_situacao_patrimonio: situacao_baixado, ativo: false)
          resultado = falha(p_patrimonio.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(baixa, HttpStatus::CREATED, "Baixa de patrimonio registrada com sucesso")
    end

    private

    attr_reader :p_patrimonio, :params, :tipo_movimentacao_codigo, :tipo_baixa_codigo

    def ja_baixado
      Result.failure([ "Patrimonio ja possui baixa registrada" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar a baixa")
    end

    def tipo_nao_configurado
      Result.failure([ "Referenciais de movimentacao/baixa nao configurados" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar a baixa")
    end

    def destino_obrigatorio
      Result.failure([ "Informe o destino externo (p_destino_externo_id ou p_destino_externo_attributes)" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar a baixa")
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel registrar a baixa")
    end
  end
end
