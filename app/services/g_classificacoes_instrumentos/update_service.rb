# frozen_string_literal: true

module GClassificacoesInstrumentos
  class UpdateService
    def self.call(g_classificacao_instrumento:, params:)
      new(g_classificacao_instrumento:, params:).call
    end

    def initialize(g_classificacao_instrumento:, params:)
      @g_classificacao_instrumento = g_classificacao_instrumento
      @params = params
    end

    def call
      if g_classificacao_instrumento.update(params)
        return Result.success(g_classificacao_instrumento, HttpStatus::OK, "Classificacao de instrumento atualizada com sucesso")
      end

      Result.failure(g_classificacao_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar classificacao de instrumento")
    end

    private

    attr_reader :g_classificacao_instrumento, :params
  end
end
