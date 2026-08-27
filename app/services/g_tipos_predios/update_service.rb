# frozen_string_literal: true

module GTiposPredios
  class UpdateService
    def self.call(g_tipo_predio:, params:)
      new(g_tipo_predio:, params:).call
    end

    def initialize(g_tipo_predio:, params:)
      @g_tipo_predio = g_tipo_predio
      @params = params
    end

    def call
      if g_tipo_predio.update(params)
        return Result.success(
          g_tipo_predio,
          HttpStatus::OK,
          "G tipo predio atualizado com sucesso"
        )
      end

      Result.failure(
        g_tipo_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g tipo predio"
      )
    end

    private

    attr_reader :g_tipo_predio, :params
  end
end
