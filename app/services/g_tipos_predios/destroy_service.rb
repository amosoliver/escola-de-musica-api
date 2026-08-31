# frozen_string_literal: true

module GTiposPredios
  class DestroyService
    def self.call(g_tipo_predio:)
      new(g_tipo_predio:).call
    end

    def initialize(g_tipo_predio:)
      @g_tipo_predio = g_tipo_predio
    end

    def call
      if g_tipo_predio.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Tipo de predio removido com sucesso"
        )
      end

      Result.failure(
        g_tipo_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g tipo predio"
      )
    end

    private

    attr_reader :g_tipo_predio
  end
end
