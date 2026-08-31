# frozen_string_literal: true

module GTiposAmbientesPrediais
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_tipo_ambiente_predial = GTipoAmbientePredial.new(params)

      if g_tipo_ambiente_predial.save
        return Result.success(
          g_tipo_ambiente_predial,
          HttpStatus::CREATED,
          "Tipo de ambiente predial criado com sucesso"
        )
      end

      Result.failure(
        g_tipo_ambiente_predial.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g tipo ambiente predial"
      )
    end

    private

    attr_reader :params
  end
end
