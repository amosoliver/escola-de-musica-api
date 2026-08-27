# frozen_string_literal: true

class Api::V1::IAmbientesPrediaisController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :i_bloco_id,
    :g_tipo_ambiente_predial_id,
    :descricao,
    :comprimento,
    :largura,
    :metros_quadrados,
    :capacidade,
    :permite_reserva,
    :ativo
  ].freeze

  before_action :set_i_ambiente_predial, only: %i[show update destroy]

  def index
    query = IAmbientePredial.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: IAmbientePredialBlueprint)
  end

  def show
    render ResponseService.success(
      data: @i_ambiente_predial,
      message: "I ambiente predial encontrado com sucesso",
      blueprint: IAmbientePredialBlueprint
    )
  end

  def create
    result = IAmbientesPrediais::CreateService.call(params: i_ambiente_predial_params)
    render ResponseService.handle_service_result(result, blueprint: IAmbientePredialBlueprint)
  end

  def update
    result = IAmbientesPrediais::UpdateService.call(i_ambiente_predial: @i_ambiente_predial, params: i_ambiente_predial_params)
    render ResponseService.handle_service_result(result, blueprint: IAmbientePredialBlueprint)
  end

  def destroy
    result = IAmbientesPrediais::DestroyService.call(i_ambiente_predial: @i_ambiente_predial)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_i_ambiente_predial
    @i_ambiente_predial = IAmbientePredial.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= IAmbientePredial.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def i_ambiente_predial_params
    params.require(:i_ambiente_predial).permit(*PERMITTED_ATTRIBUTES)
  end
end
