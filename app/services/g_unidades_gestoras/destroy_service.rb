# frozen_string_literal: true

module GUnidadesGestoras
  class DestroyService
    def self.call(g_unidade_gestora:)
      new(g_unidade_gestora:).call
    end

    def initialize(g_unidade_gestora:)
      @g_unidade_gestora = g_unidade_gestora
    end

    def call
      if g_unidade_gestora.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "G unidade gestora removido com sucesso"
        )
      end

      Result.failure(
        g_unidade_gestora.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g unidade gestora"
      )
    end

    private

    attr_reader :g_unidade_gestora
  end
end
