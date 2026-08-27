# frozen_string_literal: true

module GBairros
  class UpdateService
    def self.call(g_bairro:, params:)
      new(g_bairro:, params:).call
    end

    def initialize(g_bairro:, params:)
      @g_bairro = g_bairro
      @params = params
    end

    def call
      if g_bairro.update(params)
        return Result.success(
          g_bairro,
          HttpStatus::OK,
          "G bairro atualizado com sucesso"
        )
      end

      Result.failure(
        g_bairro.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g bairro"
      )
    end

    private

    attr_reader :g_bairro, :params
  end
end
