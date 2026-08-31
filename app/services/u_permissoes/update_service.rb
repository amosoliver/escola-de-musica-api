# frozen_string_literal: true

module UPermissoes
  class UpdateService
    def self.call(u_permissao:, params:)
      new(u_permissao:, params:).call
    end

    def initialize(u_permissao:, params:)
      @u_permissao = u_permissao
      @params = params
    end

    def call
      if u_permissao.update(params)
        return Result.success(
          u_permissao,
          HttpStatus::OK,
          "Permissao atualizada com sucesso"
        )
      end

      Result.failure(
        u_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u permissao"
      )
    end

    private

    attr_reader :u_permissao, :params
  end
end
