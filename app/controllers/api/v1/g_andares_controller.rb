# frozen_string_literal: true

class Api::V1::GAndaresController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :descricao,
    :ordem
  ].freeze

  before_action :set_g_andar, only: %i[show update destroy]

  def index
    query = scoped_g_andares.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GAndarBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_andar,
      message: "Andar encontrado com sucesso",
      blueprint: GAndarBlueprint
    )
  end

  def create
    result = GAndares::CreateService.call(params: g_andar_params)
    render ResponseService.handle_service_result(result, blueprint: GAndarBlueprint)
  end

  def update
    result = GAndares::UpdateService.call(g_andar: @g_andar, params: g_andar_params)
    render ResponseService.handle_service_result(result, blueprint: GAndarBlueprint)
  end

  def destroy
    result = GAndares::DestroyService.call(g_andar: @g_andar)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_andar
    @g_andar = GAndar.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GAndar.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def scoped_g_andares
    if params[:i_predio_id].present?
      scoped_predios = tenant_scope(IPredio.all)
      return GAndar.none if performed?

      scoped_predios.find(params[:i_predio_id])
      return GAndares::PorPredioQuery.call(i_predio_id: params[:i_predio_id])
    end

    GAndar.includes(associations_for_index)
  end

  def g_andar_params
    params.require(:g_andar).permit(*PERMITTED_ATTRIBUTES)
  end
end
