# frozen_string_literal: true

module UsersPerfis
  class DestroyService
    def self.call(user_perfil:)
      new(user_perfil:).call
    end

    def initialize(user_perfil:)
      @user_perfil = user_perfil
    end

    def call
      if user_perfil.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "User perfil removido com sucesso"
        )
      end

      Result.failure(
        user_perfil.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover user perfil"
      )
    end

    private

    attr_reader :user_perfil
  end
end
