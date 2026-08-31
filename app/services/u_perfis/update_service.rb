# frozen_string_literal: true

module UPerfis
  class UpdateService
    def self.call(u_perfil:, params:)
      new(u_perfil:, params:).call
    end

    def initialize(u_perfil:, params:)
      @u_perfil = u_perfil
      @params = params
    end

    def call
      if u_perfil.update(params)
        return Result.success(
          u_perfil,
          HttpStatus::OK,
          "Perfil atualizado com sucesso"
        )
      end

      Result.failure(
        u_perfil.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u perfil"
      )
    end

    private

    attr_reader :u_perfil, :params
  end
end
