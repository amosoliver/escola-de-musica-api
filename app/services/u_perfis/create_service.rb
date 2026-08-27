# frozen_string_literal: true

module UPerfis
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_perfil = UPerfil.new(params)

      if u_perfil.save
        return Result.success(
          u_perfil,
          HttpStatus::CREATED,
          "U perfil criado com sucesso"
        )
      end

      Result.failure(
        u_perfil.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u perfil"
      )
    end

    private

    attr_reader :params
  end
end
