# frozen_string_literal: true

module GAlergias
  class DestroyService
    def self.call(g_alergia:)
      new(g_alergia:).call
    end

    def initialize(g_alergia:)
      @g_alergia = g_alergia
    end

    def call
      if g_alergia.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Alergia removida com sucesso")
      end

      Result.failure(g_alergia.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover g alergia")
    end

    private

    attr_reader :g_alergia
  end
end
