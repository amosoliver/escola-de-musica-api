# frozen_string_literal: true

class Api::V1::GTiposAmbientesPrediaisController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :descricao,
  ].freeze

  before_action :set_g_tipo_ambiente_predial, only: %i[show update destroy]

  def index
    query = GTipoAmbientePredial.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GTipoAmbientePredialBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_tipo_ambiente_predial,
      message: "G tipo ambiente predial encontrado com sucesso",
      blueprint: GTipoAmbientePredialBlueprint
    )
  end

  def create
    result = GTiposAmbientesPrediais::CreateService.call(params: g_tipo_ambiente_predial_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoAmbientePredialBlueprint)
  end

  def update
    result = GTiposAmbientesPrediais::UpdateService.call(g_tipo_ambiente_predial: @g_tipo_ambiente_predial, params: g_tipo_ambiente_predial_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoAmbientePredialBlueprint)
  end

  def destroy
    result = GTiposAmbientesPrediais::DestroyService.call(g_tipo_ambiente_predial: @g_tipo_ambiente_predial)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_tipo_ambiente_predial
    @g_tipo_ambiente_predial = GTipoAmbientePredial.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GTipoAmbientePredial.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_tipo_ambiente_predial_params
    params.require(:g_tipo_ambiente_predial).permit(*PERMITTED_ATTRIBUTES)
  end
end
