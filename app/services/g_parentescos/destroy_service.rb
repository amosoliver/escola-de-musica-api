# frozen_string_literal: true

module GParentescos
  class DestroyService
    def self.call(g_parentesco:)
      new(g_parentesco:).call
    end

    def initialize(g_parentesco:)
      @g_parentesco = g_parentesco
    end

    def call
      if g_parentesco.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Parentesco removido com sucesso")
      end

      Result.failure(g_parentesco.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover g parentesco")
    end

    private

    attr_reader :g_parentesco
  end
end
