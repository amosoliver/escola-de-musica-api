# frozen_string_literal: true

module URotas
  class UpdateService
    def self.call(u_rota:, params:)
      new(u_rota:, params:).call
    end

    def initialize(u_rota:, params:)
      @u_rota = u_rota
      @params = params
    end

    def call
      if u_rota.update(params)
        return Result.success(
          u_rota,
          HttpStatus::OK,
          "Rota atualizada com sucesso"
        )
      end

      Result.failure(
        u_rota.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u rota"
      )
    end

    private

    attr_reader :u_rota, :params
  end
end
