# frozen_string_literal: true

module GCidades
  class UpdateService
    def self.call(g_cidade:, params:)
      new(g_cidade:, params:).call
    end

    def initialize(g_cidade:, params:)
      @g_cidade = g_cidade
      @params = params
    end

    def call
      if g_cidade.update(params)
        return Result.success(
          g_cidade,
          HttpStatus::OK,
          "G cidade atualizado com sucesso"
        )
      end

      Result.failure(
        g_cidade.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g cidade"
      )
    end

    private

    attr_reader :g_cidade, :params
  end
end
