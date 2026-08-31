# frozen_string_literal: true

module UsersPerfis
  class UpdateService
    def self.call(user_perfil:, params:)
      new(user_perfil:, params:).call
    end

    def initialize(user_perfil:, params:)
      @user_perfil = user_perfil
      @params = params
    end

    def call
      if user_perfil.update(params)
        return Result.success(
          user_perfil,
          HttpStatus::OK,
          "Perfil de usuario atualizado com sucesso"
        )
      end

      Result.failure(
        user_perfil.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar user perfil"
      )
    end

    private

    attr_reader :user_perfil, :params
  end
end
