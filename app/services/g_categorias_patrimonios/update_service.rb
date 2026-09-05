# frozen_string_literal: true

module GCategoriasPatrimonios
  class UpdateService
    def self.call(g_categoria_patrimonio:, params:)
      new(g_categoria_patrimonio:, params:).call
    end

    def initialize(g_categoria_patrimonio:, params:)
      @g_categoria_patrimonio = g_categoria_patrimonio
      @params = params
    end

    def call
      return Result.success(g_categoria_patrimonio, HttpStatus::OK, "Categoria patrimonial atualizada com sucesso") if g_categoria_patrimonio.update(params)

      Result.failure(g_categoria_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar categoria patrimonial")
    end

    private

    attr_reader :g_categoria_patrimonio, :params
  end
end
