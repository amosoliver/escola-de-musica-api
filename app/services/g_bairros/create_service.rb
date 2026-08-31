# frozen_string_literal: true

module GBairros
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_bairro = GBairro.new(params)

      if g_bairro.save
        return Result.success(
          g_bairro,
          HttpStatus::CREATED,
          "Bairro criado com sucesso"
        )
      end

      Result.failure(
        g_bairro.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g bairro"
      )
    end

    private

    attr_reader :params
  end
end
