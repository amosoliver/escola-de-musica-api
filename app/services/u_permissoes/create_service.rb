# frozen_string_literal: true

module UPermissoes
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_permissao = UPermissao.new(params)

      if u_permissao.save
        return Result.success(
          u_permissao,
          HttpStatus::CREATED,
          "Permissao criada com sucesso"
        )
      end

      Result.failure(
        u_permissao.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u permissao"
      )
    end

    private

    attr_reader :params
  end
end
