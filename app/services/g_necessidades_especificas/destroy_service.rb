# frozen_string_literal: true

module GNecessidadesEspecificas
  class DestroyService
    def self.call(g_necessidade_especifica:)
      new(g_necessidade_especifica:).call
    end

    def initialize(g_necessidade_especifica:)
      @g_necessidade_especifica = g_necessidade_especifica
    end

    def call
      if g_necessidade_especifica.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Necessidade especifica removida com sucesso")
      end

      Result.failure(
        g_necessidade_especifica.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g necessidade especifica"
      )
    end

    private

    attr_reader :g_necessidade_especifica
  end
end
