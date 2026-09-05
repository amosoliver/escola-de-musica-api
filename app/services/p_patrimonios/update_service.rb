# frozen_string_literal: true

module PPatrimonios
  # Aceita g_tipo_patrimonio_id (tipo ja cadastrado) ou g_tipo_patrimonio_attributes
  # (cadastra o tipo, e opcionalmente a categoria, na hora), via
  # GTiposPatrimonios::ResolverService.
  class UpdateService
    def self.call(p_patrimonio:, params:)
      new(p_patrimonio:, params:).call
    end

    def initialize(p_patrimonio:, params:)
      @p_patrimonio = p_patrimonio
      @params = params
    end

    def call
      atributos = params.except(:g_tipo_patrimonio_id, :g_tipo_patrimonio_attributes)
      resultado = nil

      ApplicationRecord.transaction do
        if params[:g_tipo_patrimonio_id].present? || params[:g_tipo_patrimonio_attributes].present?
          tipo_result = GTiposPatrimonios::ResolverService.call(
            g_tipo_patrimonio_id: params[:g_tipo_patrimonio_id],
            g_tipo_patrimonio_attributes: params[:g_tipo_patrimonio_attributes]
          )
          if tipo_result.failure?
            resultado = tipo_result
            raise ActiveRecord::Rollback
          end

          atributos = atributos.merge(g_tipo_patrimonio: tipo_result.value)
        end

        unless p_patrimonio.update(atributos)
          resultado = Result.failure(p_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar patrimonio")
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(p_patrimonio, HttpStatus::OK, "Patrimonio atualizado com sucesso")
    end

    private

    attr_reader :p_patrimonio, :params
  end
end
