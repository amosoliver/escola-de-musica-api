# frozen_string_literal: true

module URotas
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_rota = URota.new(params)

      if u_rota.save
        return Result.success(
          u_rota,
          HttpStatus::CREATED,
          "U rota criado com sucesso"
        )
      end

      Result.failure(
        u_rota.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u rota"
      )
    end

    private

    attr_reader :params
  end
end
