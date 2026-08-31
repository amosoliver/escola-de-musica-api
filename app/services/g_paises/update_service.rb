# frozen_string_literal: true

module GPaises
  class UpdateService
    def self.call(g_pais:, params:)
      new(g_pais:, params:).call
    end

    def initialize(g_pais:, params:)
      @g_pais = g_pais
      @params = params
    end

    def call
      if g_pais.update(params)
        return Result.success(
          g_pais,
          HttpStatus::OK,
          "Pais atualizado com sucesso"
        )
      end

      Result.failure(
        g_pais.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g pais"
      )
    end

    private

    attr_reader :g_pais, :params
  end
end
