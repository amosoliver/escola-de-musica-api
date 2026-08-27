# frozen_string_literal: true

module IAmbientesPrediais
  class UpdateService
    def self.call(i_ambiente_predial:, params:)
      new(i_ambiente_predial:, params:).call
    end

    def initialize(i_ambiente_predial:, params:)
      @i_ambiente_predial = i_ambiente_predial
      @params = params
    end

    def call
      if i_ambiente_predial.update(params)
        return Result.success(
          i_ambiente_predial,
          HttpStatus::OK,
          "I ambiente predial atualizado com sucesso"
        )
      end

      Result.failure(
        i_ambiente_predial.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar i ambiente predial"
      )
    end

    private

    attr_reader :i_ambiente_predial, :params
  end
end
