# frozen_string_literal: true

module GTiposPatrimonios
  class DestroyService
    def self.call(g_tipo_patrimonio:)
      new(g_tipo_patrimonio:).call
    end

    def initialize(g_tipo_patrimonio:)
      @g_tipo_patrimonio = g_tipo_patrimonio
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Tipo patrimonial removido com sucesso") if g_tipo_patrimonio.destroy

      Result.failure(g_tipo_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover tipo patrimonial")
    end

    private

    attr_reader :g_tipo_patrimonio
  end
end
