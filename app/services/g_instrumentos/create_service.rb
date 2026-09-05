# frozen_string_literal: true

module GInstrumentos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_instrumento = GInstrumento.new(params)
      return Result.success(g_instrumento, HttpStatus::CREATED, "Instrumento criado com sucesso") if g_instrumento.save

      Result.failure(g_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar instrumento")
    end

    private

    attr_reader :params
  end
end
