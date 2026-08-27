# frozen_string_literal: true

module GPaises
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_pais = GPais.new(params)

      if g_pais.save
        return Result.success(
          g_pais,
          HttpStatus::CREATED,
          "G pais criado com sucesso"
        )
      end

      Result.failure(
        g_pais.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g pais"
      )
    end

    private

    attr_reader :params
  end
end
