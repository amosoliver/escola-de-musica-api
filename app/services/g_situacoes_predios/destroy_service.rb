# frozen_string_literal: true

module GSituacoesPredios
  class DestroyService
    def self.call(g_situacao_predio:)
      new(g_situacao_predio:).call
    end

    def initialize(g_situacao_predio:)
      @g_situacao_predio = g_situacao_predio
    end

    def call
      if g_situacao_predio.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Situacao do predio removida com sucesso"
        )
      end

      Result.failure(
        g_situacao_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g situacao predio"
      )
    end

    private

    attr_reader :g_situacao_predio
  end
end
