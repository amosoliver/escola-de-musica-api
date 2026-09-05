# frozen_string_literal: true

class Api::V1::GTiposPatrimoniosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[g_categoria_patrimonio_id codigo descricao representa_instrumento ativo].freeze
  CATEGORIA_ATTRIBUTES = %i[codigo descricao ativo].freeze

  before_action :set_g_tipo_patrimonio, only: %i[show update destroy]

  def index
    query = GTipoPatrimonio.includes(:g_categoria_patrimonio).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GTipoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @g_tipo_patrimonio, message: "Tipo patrimonial encontrado com sucesso", blueprint: GTipoPatrimonioBlueprint)
  end

  def create
    result = GTiposPatrimonios::CreateService.call(params: g_tipo_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoPatrimonioBlueprint)
  end

  def update
    result = GTiposPatrimonios::UpdateService.call(g_tipo_patrimonio: @g_tipo_patrimonio, params: g_tipo_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoPatrimonioBlueprint)
  end

  def destroy
    result = GTiposPatrimonios::DestroyService.call(g_tipo_patrimonio: @g_tipo_patrimonio)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_tipo_patrimonio
    @g_tipo_patrimonio = GTipoPatrimonio.find(params[:id])
  end

  def g_tipo_patrimonio_params
    params.require(:g_tipo_patrimonio).permit(
      *PERMITTED_ATTRIBUTES, g_categoria_patrimonio_attributes: CATEGORIA_ATTRIBUTES
    ).to_h.deep_symbolize_keys
  end
end
