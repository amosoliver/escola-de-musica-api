# frozen_string_literal: true

module GTiposInstrumentos
  class UpdateService
    def self.call(g_tipo_instrumento:, params:)
      new(g_tipo_instrumento:, params:).call
    end

    def initialize(g_tipo_instrumento:, params:)
      @g_tipo_instrumento = g_tipo_instrumento
      @params = params
    end

    def call
      if g_tipo_instrumento.update(params)
        return Result.success(g_tipo_instrumento, HttpStatus::OK, "Tipo de instrumento atualizado com sucesso")
      end

      Result.failure(g_tipo_instrumento.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar tipo de instrumento")
    end

    private

    attr_reader :g_tipo_instrumento, :params
  end
end
