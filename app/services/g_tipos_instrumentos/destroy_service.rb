# frozen_string_literal: true

module GTiposInstrumentos
  class DestroyService
    def self.call(g_tipo_instrumento:)
      new(g_tipo_instrumento:).call
    end

    def initialize(g_tipo_instrumento:)
      @g_tipo_instrumento = g_tipo_instrumento
    end

    def call
      if g_tipo_instrumento.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Tipo de instrumento removido com sucesso")
      end

      Result.failure(g_tipo_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover tipo de instrumento")
    end

    private

    attr_reader :g_tipo_instrumento
  end
end
