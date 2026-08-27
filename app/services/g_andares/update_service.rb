# frozen_string_literal: true

module GAndares
  class UpdateService
    def self.call(g_andar:, params:)
      new(g_andar:, params:).call
    end

    def initialize(g_andar:, params:)
      @g_andar = g_andar
      @params = params
    end

    def call
      if g_andar.update(params)
        return Result.success(
          g_andar,
          HttpStatus::OK,
          "G andar atualizado com sucesso"
        )
      end

      Result.failure(
        g_andar.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g andar"
      )
    end

    private

    attr_reader :g_andar, :params
  end
end
