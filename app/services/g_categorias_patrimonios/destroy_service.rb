# frozen_string_literal: true

module GCategoriasPatrimonios
  class DestroyService
    def self.call(g_categoria_patrimonio:)
      new(g_categoria_patrimonio:).call
    end

    def initialize(g_categoria_patrimonio:)
      @g_categoria_patrimonio = g_categoria_patrimonio
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Categoria patrimonial removida com sucesso") if g_categoria_patrimonio.destroy

      Result.failure(g_categoria_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover categoria patrimonial")
    end

    private

    attr_reader :g_categoria_patrimonio
  end
end
