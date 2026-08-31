# frozen_string_literal: true

module URotasPermissoes
  class DestroyService
    def self.call(u_rota_permissao:)
      new(u_rota_permissao:).call
    end

    def initialize(u_rota_permissao:)
      @u_rota_permissao = u_rota_permissao
    end

    def call
      if u_rota_permissao.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Permissao de rota removida com sucesso"
        )
      end

      Result.failure(
        u_rota_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u rota permissao"
      )
    end

    private

    attr_reader :u_rota_permissao
  end
end
