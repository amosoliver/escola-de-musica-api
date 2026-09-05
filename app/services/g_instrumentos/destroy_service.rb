# frozen_string_literal: true

module GInstrumentos
  class DestroyService
    def self.call(g_instrumento:)
      new(g_instrumento:).call
    end

    def initialize(g_instrumento:)
      @g_instrumento = g_instrumento
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Instrumento removido com sucesso") if g_instrumento.destroy

      Result.failure(g_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover instrumento")
    end

    private

    attr_reader :g_instrumento
  end
end
