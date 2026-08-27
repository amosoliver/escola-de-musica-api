# frozen_string_literal: true

module IPredios
  class UpdateService
    def self.call(i_predio:, params:)
      new(i_predio:, params:).call
    end

    def initialize(i_predio:, params:)
      @i_predio = i_predio
      @params = params
    end

    def call
      if i_predio.update(params)
        return Result.success(
          i_predio,
          HttpStatus::OK,
          "I predio atualizado com sucesso"
        )
      end

      Result.failure(
        i_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar i predio"
      )
    end

    private

    attr_reader :i_predio, :params
  end
end
