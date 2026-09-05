# frozen_string_literal: true

module GTiposPatrimonios
  # Resolve um tipo patrimonial existente (por id) ou cria um novo a partir dos
  # atributos informados. Quando cria um novo tipo, a categoria patrimonial
  # tambem pode ser informada por id ou cadastrada na hora (via
  # GCategoriasPatrimonios::ResolverService), permitindo montar toda a
  # classificacao no mesmo formulario aninhado do cadastro de patrimonio.
  class ResolverService
    def self.call(g_tipo_patrimonio_id: nil, g_tipo_patrimonio_attributes: nil)
      new(g_tipo_patrimonio_id:, g_tipo_patrimonio_attributes:).call
    end

    def initialize(g_tipo_patrimonio_id:, g_tipo_patrimonio_attributes:)
      @g_tipo_patrimonio_id = g_tipo_patrimonio_id
      @g_tipo_patrimonio_attributes = g_tipo_patrimonio_attributes
    end

    def call
      return Result.success(nil) if g_tipo_patrimonio_id.blank? && g_tipo_patrimonio_attributes.blank?
      return buscar_existente if g_tipo_patrimonio_id.present?

      criar_novo
    end

    private

    attr_reader :g_tipo_patrimonio_id, :g_tipo_patrimonio_attributes

    def buscar_existente
      tipo = GTipoPatrimonio.find_by(id: g_tipo_patrimonio_id)
      return Result.failure([ "Tipo patrimonial nao encontrado" ], HttpStatus::UNPROCESSABLE_ENTITY, "Tipo patrimonial nao encontrado") if tipo.blank?

      Result.success(tipo)
    end

    def criar_novo
      atributos = g_tipo_patrimonio_attributes.except(:g_categoria_patrimonio_id, :g_categoria_patrimonio_attributes)

      categoria_result = GCategoriasPatrimonios::ResolverService.call(
        g_categoria_patrimonio_id: g_tipo_patrimonio_attributes[:g_categoria_patrimonio_id],
        g_categoria_patrimonio_attributes: g_tipo_patrimonio_attributes[:g_categoria_patrimonio_attributes]
      )
      return categoria_result if categoria_result.failure?

      tipo = GTipoPatrimonio.new(atributos.merge(g_categoria_patrimonio: categoria_result.value))
      return Result.success(tipo, HttpStatus::CREATED) if tipo.save

      Result.failure(tipo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel cadastrar tipo patrimonial")
    end
  end
end
