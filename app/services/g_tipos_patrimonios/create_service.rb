# frozen_string_literal: true

module GTiposPatrimonios
  # Aceita g_categoria_patrimonio_id (categoria ja cadastrada) ou
  # g_categoria_patrimonio_attributes (cadastra a categoria na hora), via
  # GCategoriasPatrimonios::ResolverService.
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      atributos = params.except(:g_categoria_patrimonio_id, :g_categoria_patrimonio_attributes)

      categoria_result = GCategoriasPatrimonios::ResolverService.call(
        g_categoria_patrimonio_id: params[:g_categoria_patrimonio_id],
        g_categoria_patrimonio_attributes: params[:g_categoria_patrimonio_attributes]
      )
      return categoria_result if categoria_result.failure?

      g_tipo_patrimonio = GTipoPatrimonio.new(atributos.merge(g_categoria_patrimonio: categoria_result.value))
      return Result.success(g_tipo_patrimonio, HttpStatus::CREATED, "Tipo patrimonial criado com sucesso") if g_tipo_patrimonio.save

      Result.failure(g_tipo_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar tipo patrimonial")
    end

    private

    attr_reader :params
  end
end
