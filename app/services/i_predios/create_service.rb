# frozen_string_literal: true

module IPredios
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      i_predio = IPredio.new(params)

      if i_predio.save
        return Result.success(
          i_predio,
          HttpStatus::CREATED,
          "I predio criado com sucesso"
        )
      end

      Result.failure(
        i_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar i predio"
      )
    end

    private

    attr_reader :params
  end
end
