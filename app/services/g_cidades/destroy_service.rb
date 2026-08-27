# frozen_string_literal: true

module GCidades
  class DestroyService
    def self.call(g_cidade:)
      new(g_cidade:).call
    end

    def initialize(g_cidade:)
      @g_cidade = g_cidade
    end

    def call
      if g_cidade.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "G cidade removido com sucesso"
        )
      end

      Result.failure(
        g_cidade.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g cidade"
      )
    end

    private

    attr_reader :g_cidade
  end
end
