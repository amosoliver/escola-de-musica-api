# frozen_string_literal: true

module IBlocos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      i_bloco = IBloco.new(params)

      if i_bloco.save
        return Result.success(
          i_bloco,
          HttpStatus::CREATED,
          "Bloco criado com sucesso"
        )
      end

      Result.failure(
        i_bloco.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar i bloco"
      )
    end

    private

    attr_reader :params
  end
end
