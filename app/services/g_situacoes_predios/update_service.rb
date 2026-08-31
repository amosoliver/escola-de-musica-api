# frozen_string_literal: true

module GSituacoesPredios
  class UpdateService
    def self.call(g_situacao_predio:, params:)
      new(g_situacao_predio:, params:).call
    end

    def initialize(g_situacao_predio:, params:)
      @g_situacao_predio = g_situacao_predio
      @params = params
    end

    def call
      if g_situacao_predio.update(params)
        return Result.success(
          g_situacao_predio,
          HttpStatus::OK,
          "Situacao do predio atualizada com sucesso"
        )
      end

      Result.failure(
        g_situacao_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g situacao predio"
      )
    end

    private

    attr_reader :g_situacao_predio, :params
  end
end
