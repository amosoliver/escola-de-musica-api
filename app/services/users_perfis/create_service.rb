# frozen_string_literal: true

module UsersPerfis
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      user_perfil = UserPerfil.new(params)

      if user_perfil.save
        return Result.success(
          user_perfil,
          HttpStatus::CREATED,
          "User perfil criado com sucesso"
        )
      end

      Result.failure(
        user_perfil.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar user perfil"
      )
    end

    private

    attr_reader :params
  end
end
