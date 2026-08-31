# frozen_string_literal: true

module UPerfis
  class DestroyService
    def self.call(u_perfil:)
      new(u_perfil:).call
    end

    def initialize(u_perfil:)
      @u_perfil = u_perfil
    end

    def call
      if u_perfil.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Perfil removido com sucesso"
        )
      end

      Result.failure(
        u_perfil.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u perfil"
      )
    end

    private

    attr_reader :u_perfil
  end
end
