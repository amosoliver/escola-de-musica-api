# frozen_string_literal: true

class Api::V1::GNecessidadesEspecificasController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[descricao ativo].freeze

  before_action :set_g_necessidade_especifica, only: %i[show update destroy]

  def index
    query = GNecessidadeEspecifica.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GNecessidadeEspecificaBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_necessidade_especifica,
      message: "Necessidade especifica encontrada com sucesso",
      blueprint: GNecessidadeEspecificaBlueprint
    )
  end

  def create
    result = GNecessidadesEspecificas::CreateService.call(params: g_necessidade_especifica_params)
    render ResponseService.handle_service_result(result, blueprint: GNecessidadeEspecificaBlueprint)
  end

  def update
    result = GNecessidadesEspecificas::UpdateService.call(
      g_necessidade_especifica: @g_necessidade_especifica,
      params: g_necessidade_especifica_params
    )
    render ResponseService.handle_service_result(result, blueprint: GNecessidadeEspecificaBlueprint)
  end

  def destroy
    result = GNecessidadesEspecificas::DestroyService.call(g_necessidade_especifica: @g_necessidade_especifica)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_necessidade_especifica
    @g_necessidade_especifica = GNecessidadeEspecifica.find(params[:id])
  end

  def g_necessidade_especifica_params
    params.require(:g_necessidade_especifica).permit(*PERMITTED_ATTRIBUTES)
  end
end
