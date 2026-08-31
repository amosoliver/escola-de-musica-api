# frozen_string_literal: true

module IAmbientesPrediais
  class DestroyService
    def self.call(i_ambiente_predial:)
      new(i_ambiente_predial:).call
    end

    def initialize(i_ambiente_predial:)
      @i_ambiente_predial = i_ambiente_predial
    end

    def call
      if i_ambiente_predial.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Ambiente predial removido com sucesso"
        )
      end

      Result.failure(
        i_ambiente_predial.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover i ambiente predial"
      )
    end

    private

    attr_reader :i_ambiente_predial
  end
end
