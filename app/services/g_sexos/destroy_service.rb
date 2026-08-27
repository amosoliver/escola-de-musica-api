# frozen_string_literal: true

module GSexos
  class DestroyService
    def self.call(g_sexo:)
      new(g_sexo:).call
    end

    def initialize(g_sexo:)
      @g_sexo = g_sexo
    end

    def call
      if g_sexo.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "G sexo removido com sucesso"
        )
      end

      Result.failure(
        g_sexo.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g sexo"
      )
    end

    private

    attr_reader :g_sexo
  end
end
