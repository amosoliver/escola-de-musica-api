# frozen_string_literal: true

module GNecessidadesEspecificas
  class UpdateService
    def self.call(g_necessidade_especifica:, params:)
      new(g_necessidade_especifica:, params:).call
    end

    def initialize(g_necessidade_especifica:, params:)
      @g_necessidade_especifica = g_necessidade_especifica
      @params = params
    end

    def call
      if g_necessidade_especifica.update(params)
        return Result.success(g_necessidade_especifica, HttpStatus::OK, "Necessidade especifica atualizada com sucesso")
      end

      Result.failure(
        g_necessidade_especifica.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g necessidade especifica"
      )
    end

    private

    attr_reader :g_necessidade_especifica, :params
  end
end
