# frozen_string_literal: true

module UPerfisPermissoes
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_perfil_permissao = UPerfilPermissao.new(params)

      if u_perfil_permissao.save
        return Result.success(
          u_perfil_permissao,
          HttpStatus::CREATED,
          "U perfil permissao criado com sucesso"
        )
      end

      Result.failure(
        u_perfil_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u perfil permissao"
      )
    end

    private

    attr_reader :params
  end
end
