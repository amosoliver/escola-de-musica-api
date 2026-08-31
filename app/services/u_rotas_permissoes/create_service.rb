# frozen_string_literal: true

module URotasPermissoes
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_rota_permissao = URotaPermissao.new(params)

      if u_rota_permissao.save
        return Result.success(
          u_rota_permissao,
          HttpStatus::CREATED,
          "Permissao de rota criada com sucesso"
        )
      end

      Result.failure(
        u_rota_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u rota permissao"
      )
    end

    private

    attr_reader :params
  end
end
