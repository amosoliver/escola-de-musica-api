# frozen_string_literal: true

class Api::V1::GAlergiasController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[descricao ativo].freeze

  before_action :set_g_alergia, only: %i[show update destroy]

  def index
    query = GAlergia.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GAlergiaBlueprint)
  end

  def show
    render ResponseService.success(data: @g_alergia, message: "Alergia encontrada com sucesso", blueprint: GAlergiaBlueprint)
  end

  def create
    result = GAlergias::CreateService.call(params: g_alergia_params)
    render ResponseService.handle_service_result(result, blueprint: GAlergiaBlueprint)
  end

  def update
    result = GAlergias::UpdateService.call(g_alergia: @g_alergia, params: g_alergia_params)
    render ResponseService.handle_service_result(result, blueprint: GAlergiaBlueprint)
  end

  def destroy
    result = GAlergias::DestroyService.call(g_alergia: @g_alergia)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_alergia
    @g_alergia = GAlergia.find(params[:id])
  end

  def g_alergia_params
    params.require(:g_alergia).permit(*PERMITTED_ATTRIBUTES)
  end
end
