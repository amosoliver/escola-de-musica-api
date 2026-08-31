# frozen_string_literal: true

module GAndares
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_andar = GAndar.new(params)

      if g_andar.save
        return Result.success(
          g_andar,
          HttpStatus::CREATED,
          "Andar criado com sucesso"
        )
      end

      Result.failure(
        g_andar.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g andar"
      )
    end

    private

    attr_reader :params
  end
end
