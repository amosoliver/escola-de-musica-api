# frozen_string_literal: true

module URotasPermissoes
  class UpdateService
    def self.call(u_rota_permissao:, params:)
      new(u_rota_permissao:, params:).call
    end

    def initialize(u_rota_permissao:, params:)
      @u_rota_permissao = u_rota_permissao
      @params = params
    end

    def call
      if u_rota_permissao.update(params)
        return Result.success(
          u_rota_permissao,
          HttpStatus::OK,
          "Permissao de rota atualizada com sucesso"
        )
      end

      Result.failure(
        u_rota_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u rota permissao"
      )
    end

    private

    attr_reader :u_rota_permissao, :params
  end
end
