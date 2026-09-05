# frozen_string_literal: true

module GClassificacoesInstrumentos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_classificacao_instrumento = GClassificacaoInstrumento.new(params)
      if g_classificacao_instrumento.save
        return Result.success(g_classificacao_instrumento, HttpStatus::CREATED, "Classificacao de instrumento criada com sucesso")
      end

      Result.failure(g_classificacao_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar classificacao de instrumento")
    end

    private

    attr_reader :params
  end
end
