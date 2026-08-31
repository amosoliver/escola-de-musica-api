# frozen_string_literal: true

module GParentescos
  class UpdateService
    def self.call(g_parentesco:, params:)
      new(g_parentesco:, params:).call
    end

    def initialize(g_parentesco:, params:)
      @g_parentesco = g_parentesco
      @params = params
    end

    def call
      if g_parentesco.update(params)
        return Result.success(g_parentesco, HttpStatus::OK, "Parentesco atualizado com sucesso")
      end

      Result.failure(g_parentesco.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar g parentesco")
    end

    private

    attr_reader :g_parentesco, :params
  end
end
