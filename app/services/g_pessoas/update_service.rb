# frozen_string_literal: true

module GPessoas
  class UpdateService
    def self.call(g_pessoa:, params:)
      new(g_pessoa:, params:).call
    end

    def initialize(g_pessoa:, params:)
      @g_pessoa = g_pessoa
      @params = params
    end

    def call
      if g_pessoa.update(params)
        return Result.success(
          g_pessoa,
          HttpStatus::OK,
          "G pessoa atualizado com sucesso"
        )
      end

      Result.failure(
        g_pessoa.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g pessoa"
      )
    end

    private

    attr_reader :g_pessoa, :params
  end
end
