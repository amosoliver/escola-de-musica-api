# frozen_string_literal: true

module PPatrimonios
  # Aceita g_tipo_patrimonio_id (tipo ja cadastrado) ou g_tipo_patrimonio_attributes
  # (cadastra o tipo, e opcionalmente a categoria, na hora), via
  # GTiposPatrimonios::ResolverService.
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      atributos = params.except(:g_tipo_patrimonio_id, :g_tipo_patrimonio_attributes)
      resultado = nil
      p_patrimonio = nil

      ApplicationRecord.transaction do
        tipo_result = GTiposPatrimonios::ResolverService.call(
          g_tipo_patrimonio_id: params[:g_tipo_patrimonio_id],
          g_tipo_patrimonio_attributes: params[:g_tipo_patrimonio_attributes]
        )
        if tipo_result.failure?
          resultado = tipo_result
          raise ActiveRecord::Rollback
        end

        p_patrimonio = PPatrimonio.new(atributos.merge(g_tipo_patrimonio: tipo_result.value))
        unless p_patrimonio.save
          resultado = Result.failure(p_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel cadastrar patrimonio")
          raise ActiveRecord::Rollback
        end
      end

      resultado || Result.success(p_patrimonio, HttpStatus::CREATED, "Patrimonio cadastrado com sucesso")
    end

    private

    attr_reader :params
  end
end
