# frozen_string_literal: true

class Api::V1::GTiposPrediosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :descricao,
  ].freeze

  before_action :set_g_tipo_predio, only: %i[show update destroy]

  def index
    query = GTipoPredio.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GTipoPredioBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_tipo_predio,
      message: "Tipo de predio encontrado com sucesso",
      blueprint: GTipoPredioBlueprint
    )
  end

  def create
    result = GTiposPredios::CreateService.call(params: g_tipo_predio_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoPredioBlueprint)
  end

  def update
    result = GTiposPredios::UpdateService.call(g_tipo_predio: @g_tipo_predio, params: g_tipo_predio_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoPredioBlueprint)
  end

  def destroy
    result = GTiposPredios::DestroyService.call(g_tipo_predio: @g_tipo_predio)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_tipo_predio
    @g_tipo_predio = GTipoPredio.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GTipoPredio.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_tipo_predio_params
    params.require(:g_tipo_predio).permit(*PERMITTED_ATTRIBUTES)
  end
end
