# frozen_string_literal: true

module GClassificacoesInstrumentos
  class DestroyService
    def self.call(g_classificacao_instrumento:)
      new(g_classificacao_instrumento:).call
    end

    def initialize(g_classificacao_instrumento:)
      @g_classificacao_instrumento = g_classificacao_instrumento
    end

    def call
      if g_classificacao_instrumento.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Classificacao de instrumento removida com sucesso")
      end

      Result.failure(g_classificacao_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover classificacao de instrumento")
    end

    private

    attr_reader :g_classificacao_instrumento
  end
end
