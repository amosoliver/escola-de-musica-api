# frozen_string_literal: true

module GPessoas
  class DestroyService
    def self.call(g_pessoa:)
      new(g_pessoa:).call
    end

    def initialize(g_pessoa:)
      @g_pessoa = g_pessoa
    end

    def call
      if g_pessoa.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "G pessoa removido com sucesso"
        )
      end

      Result.failure(
        g_pessoa.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g pessoa"
      )
    end

    private

    attr_reader :g_pessoa
  end
end
