# frozen_string_literal: true

module GCategoriasPatrimonios
  # Resolve uma categoria patrimonial existente (por id) ou cria uma nova a
  # partir dos atributos informados, para o formulario aninhado do cadastro de
  # tipo/categoria patrimonial.
  class ResolverService
    def self.call(g_categoria_patrimonio_id: nil, g_categoria_patrimonio_attributes: nil)
      new(g_categoria_patrimonio_id:, g_categoria_patrimonio_attributes:).call
    end

    def initialize(g_categoria_patrimonio_id:, g_categoria_patrimonio_attributes:)
      @g_categoria_patrimonio_id = g_categoria_patrimonio_id
      @g_categoria_patrimonio_attributes = g_categoria_patrimonio_attributes
    end

    def call
      return buscar_existente if g_categoria_patrimonio_id.present?
      return criar_novo if g_categoria_patrimonio_attributes.present?

      Result.failure([ "Informe g_categoria_patrimonio_id ou g_categoria_patrimonio_attributes" ], HttpStatus::UNPROCESSABLE_ENTITY, "Categoria patrimonial nao informada")
    end

    private

    attr_reader :g_categoria_patrimonio_id, :g_categoria_patrimonio_attributes

    def buscar_existente
      categoria = GCategoriaPatrimonio.find_by(id: g_categoria_patrimonio_id)
      return Result.failure([ "Categoria patrimonial nao encontrada" ], HttpStatus::UNPROCESSABLE_ENTITY, "Categoria patrimonial nao encontrada") if categoria.blank?

      Result.success(categoria)
    end

    def criar_novo
      categoria = GCategoriaPatrimonio.new(g_categoria_patrimonio_attributes)
      return Result.success(categoria, HttpStatus::CREATED) if categoria.save

      Result.failure(categoria.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel cadastrar categoria patrimonial")
    end
  end
end
