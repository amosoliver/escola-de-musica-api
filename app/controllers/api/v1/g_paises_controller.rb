# frozen_string_literal: true

class Api::V1::GPaisesController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :descricao,
    :sigla,
    :codigo_iso,
  ].freeze

  before_action :set_g_pais, only: %i[show update destroy]

  def index
    query = GPais.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GPaisBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_pais,
      message: "G pais encontrado com sucesso",
      blueprint: GPaisBlueprint
    )
  end

  def create
    result = GPaises::CreateService.call(params: g_pais_params)
    render ResponseService.handle_service_result(result, blueprint: GPaisBlueprint)
  end

  def update
    result = GPaises::UpdateService.call(g_pais: @g_pais, params: g_pais_params)
    render ResponseService.handle_service_result(result, blueprint: GPaisBlueprint)
  end

  def destroy
    result = GPaises::DestroyService.call(g_pais: @g_pais)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_pais
    @g_pais = GPais.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GPais.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_pais_params
    params.require(:g_pais).permit(*PERMITTED_ATTRIBUTES)
  end
end
