# frozen_string_literal: true

module GTiposPredios
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_tipo_predio = GTipoPredio.new(params)

      if g_tipo_predio.save
        return Result.success(
          g_tipo_predio,
          HttpStatus::CREATED,
          "Tipo de predio criado com sucesso"
        )
      end

      Result.failure(
        g_tipo_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g tipo predio"
      )
    end

    private

    attr_reader :params
  end
end
