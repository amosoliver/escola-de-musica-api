# frozen_string_literal: true

module GAlergias
  class UpdateService
    def self.call(g_alergia:, params:)
      new(g_alergia:, params:).call
    end

    def initialize(g_alergia:, params:)
      @g_alergia = g_alergia
      @params = params
    end

    def call
      if g_alergia.update(params)
        return Result.success(g_alergia, HttpStatus::OK, "Alergia atualizada com sucesso")
      end

      Result.failure(g_alergia.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar g alergia")
    end

    private

    attr_reader :g_alergia, :params
  end
end
