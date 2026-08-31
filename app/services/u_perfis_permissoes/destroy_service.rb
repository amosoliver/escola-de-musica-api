# frozen_string_literal: true

module UPerfisPermissoes
  class DestroyService
    def self.call(u_perfil_permissao:)
      new(u_perfil_permissao:).call
    end

    def initialize(u_perfil_permissao:)
      @u_perfil_permissao = u_perfil_permissao
    end

    def call
      if u_perfil_permissao.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Perfil permissao removido com sucesso"
        )
      end

      Result.failure(
        u_perfil_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u perfil permissao"
      )
    end

    private

    attr_reader :u_perfil_permissao
  end
end
