# frozen_string_literal: true

module UPermissoes
  class DestroyService
    def self.call(u_permissao:)
      new(u_permissao:).call
    end

    def initialize(u_permissao:)
      @u_permissao = u_permissao
    end

    def call
      if u_permissao.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "U permissao removido com sucesso"
        )
      end

      Result.failure(
        u_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u permissao"
      )
    end

    private

    attr_reader :u_permissao
  end
end
