# frozen_string_literal: true

module IAmbientesPrediais
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      i_ambiente_predial = IAmbientePredial.new(params)

      if i_ambiente_predial.save
        return Result.success(
          i_ambiente_predial,
          HttpStatus::CREATED,
          "I ambiente predial criado com sucesso"
        )
      end

      Result.failure(
        i_ambiente_predial.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar i ambiente predial"
      )
    end

    private

    attr_reader :params
  end
end
