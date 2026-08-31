# frozen_string_literal: true

module URotas
  class DestroyService
    def self.call(u_rota:)
      new(u_rota:).call
    end

    def initialize(u_rota:)
      @u_rota = u_rota
    end

    def call
      if u_rota.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Rota removida com sucesso"
        )
      end

      Result.failure(
        u_rota.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u rota"
      )
    end

    private

    attr_reader :u_rota
  end
end
