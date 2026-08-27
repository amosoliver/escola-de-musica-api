# frozen_string_literal: true

module GCidades
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_cidade = GCidade.new(params)

      if g_cidade.save
        return Result.success(
          g_cidade,
          HttpStatus::CREATED,
          "G cidade criado com sucesso"
        )
      end

      Result.failure(
        g_cidade.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g cidade"
      )
    end

    private

    attr_reader :params
  end
end
