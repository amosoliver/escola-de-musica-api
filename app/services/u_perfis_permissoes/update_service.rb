# frozen_string_literal: true

module UPerfisPermissoes
  class UpdateService
    def self.call(u_perfil_permissao:, params:)
      new(u_perfil_permissao:, params:).call
    end

    def initialize(u_perfil_permissao:, params:)
      @u_perfil_permissao = u_perfil_permissao
      @params = params
    end

    def call
      if u_perfil_permissao.update(params)
        return Result.success(
          u_perfil_permissao,
          HttpStatus::OK,
          "U perfil permissao atualizado com sucesso"
        )
      end

      Result.failure(
        u_perfil_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u perfil permissao"
      )
    end

    private

    attr_reader :u_perfil_permissao, :params
  end
end
