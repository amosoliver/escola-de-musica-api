# frozen_string_literal: true

module GAndares
  class DestroyService
    def self.call(g_andar:)
      new(g_andar:).call
    end

    def initialize(g_andar:)
      @g_andar = g_andar
    end

    def call
      if g_andar.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Andar removido com sucesso"
        )
      end

      Result.failure(
        g_andar.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g andar"
      )
    end

    private

    attr_reader :g_andar
  end
end
