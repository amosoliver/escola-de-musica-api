# frozen_string_literal: true

module GTiposPatrimonios
  class UpdateService
    def self.call(g_tipo_patrimonio:, params:)
      new(g_tipo_patrimonio:, params:).call
    end

    def initialize(g_tipo_patrimonio:, params:)
      @g_tipo_patrimonio = g_tipo_patrimonio
      @params = params
    end

    def call
      atributos = params.except(:g_categoria_patrimonio_id, :g_categoria_patrimonio_attributes)

      if params[:g_categoria_patrimonio_id].present? || params[:g_categoria_patrimonio_attributes].present?
        categoria_result = GCategoriasPatrimonios::ResolverService.call(
          g_categoria_patrimonio_id: params[:g_categoria_patrimonio_id],
          g_categoria_patrimonio_attributes: params[:g_categoria_patrimonio_attributes]
        )
        return categoria_result if categoria_result.failure?

        atributos = atributos.merge(g_categoria_patrimonio: categoria_result.value)
      end

      return Result.success(g_tipo_patrimonio, HttpStatus::OK, "Tipo patrimonial atualizado com sucesso") if g_tipo_patrimonio.update(atributos)

      Result.failure(g_tipo_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar tipo patrimonial")
    end

    private

    attr_reader :g_tipo_patrimonio, :params
  end
end
