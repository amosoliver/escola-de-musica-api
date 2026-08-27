# frozen_string_literal: true

module GPaises
  class DestroyService
    def self.call(g_pais:)
      new(g_pais:).call
    end

    def initialize(g_pais:)
      @g_pais = g_pais
    end

    def call
      if g_pais.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "G pais removido com sucesso"
        )
      end

      Result.failure(
        g_pais.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g pais"
      )
    end

    private

    attr_reader :g_pais
  end
end
