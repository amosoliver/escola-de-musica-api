# frozen_string_literal: true

module GTiposInstrumentos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_tipo_instrumento = GTipoInstrumento.new(params)
      if g_tipo_instrumento.save
        return Result.success(g_tipo_instrumento, HttpStatus::CREATED, "Tipo de instrumento criado com sucesso")
      end

      Result.failure(g_tipo_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar tipo de instrumento")
    end

    private

    attr_reader :params
  end
end
