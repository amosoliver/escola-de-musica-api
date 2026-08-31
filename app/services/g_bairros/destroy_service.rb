# frozen_string_literal: true

module GBairros
  class DestroyService
    def self.call(g_bairro:)
      new(g_bairro:).call
    end

    def initialize(g_bairro:)
      @g_bairro = g_bairro
    end

    def call
      if g_bairro.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Bairro removido com sucesso"
        )
      end

      Result.failure(
        g_bairro.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g bairro"
      )
    end

    private

    attr_reader :g_bairro
  end
end
