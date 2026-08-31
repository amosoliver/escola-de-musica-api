# frozen_string_literal: true

module GTiposAmbientesPrediais
  class UpdateService
    def self.call(g_tipo_ambiente_predial:, params:)
      new(g_tipo_ambiente_predial:, params:).call
    end

    def initialize(g_tipo_ambiente_predial:, params:)
      @g_tipo_ambiente_predial = g_tipo_ambiente_predial
      @params = params
    end

    def call
      if g_tipo_ambiente_predial.update(params)
        return Result.success(
          g_tipo_ambiente_predial,
          HttpStatus::OK,
          "Tipo de ambiente predial atualizado com sucesso"
        )
      end

      Result.failure(
        g_tipo_ambiente_predial.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g tipo ambiente predial"
      )
    end

    private

    attr_reader :g_tipo_ambiente_predial, :params
  end
end
