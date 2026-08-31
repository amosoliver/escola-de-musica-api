# frozen_string_literal: true

module GSexos
  class UpdateService
    def self.call(g_sexo:, params:)
      new(g_sexo:, params:).call
    end

    def initialize(g_sexo:, params:)
      @g_sexo = g_sexo
      @params = params
    end

    def call
      if g_sexo.update(params)
        return Result.success(
          g_sexo,
          HttpStatus::OK,
          "Sexo atualizado com sucesso"
        )
      end

      Result.failure(
        g_sexo.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g sexo"
      )
    end

    private

    attr_reader :g_sexo, :params
  end
end
