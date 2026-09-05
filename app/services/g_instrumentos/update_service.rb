# frozen_string_literal: true

module GInstrumentos
  class UpdateService
    def self.call(g_instrumento:, params:)
      new(g_instrumento:, params:).call
    end

    def initialize(g_instrumento:, params:)
      @g_instrumento = g_instrumento
      @params = params
    end

    def call
      return Result.success(g_instrumento, HttpStatus::OK, "Instrumento atualizado com sucesso") if g_instrumento.update(params)

      Result.failure(g_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar instrumento")
    end

    private

    attr_reader :g_instrumento, :params
  end
end
