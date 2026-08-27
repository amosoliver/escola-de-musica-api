# frozen_string_literal: true

module GUnidadesGestoras
  class UpdateService
    def self.call(g_unidade_gestora:, params:)
      new(g_unidade_gestora:, params:).call
    end

    def initialize(g_unidade_gestora:, params:)
      @g_unidade_gestora = g_unidade_gestora
      @params = params
    end

    def call
      if g_unidade_gestora.update(params)
        return Result.success(
          g_unidade_gestora,
          HttpStatus::OK,
          "G unidade gestora atualizado com sucesso"
        )
      end

      Result.failure(
        g_unidade_gestora.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g unidade gestora"
      )
    end

    private

    attr_reader :g_unidade_gestora, :params
  end
end
