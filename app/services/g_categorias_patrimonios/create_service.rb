# frozen_string_literal: true

module GCategoriasPatrimonios
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_categoria_patrimonio = GCategoriaPatrimonio.new(params)
      return Result.success(g_categoria_patrimonio, HttpStatus::CREATED, "Categoria patrimonial criada com sucesso") if g_categoria_patrimonio.save

      Result.failure(g_categoria_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar categoria patrimonial")
    end

    private

    attr_reader :params
  end
end
