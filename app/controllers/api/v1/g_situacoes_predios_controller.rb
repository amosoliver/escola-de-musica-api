# frozen_string_literal: true

class Api::V1::GSituacoesPrediosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :descricao,
  ].freeze

  before_action :set_g_situacao_predio, only: %i[show update destroy]

  def index
    query = GSituacaoPredio.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GSituacaoPredioBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_situacao_predio,
      message: "Situacao do predio encontrada com sucesso",
      blueprint: GSituacaoPredioBlueprint
    )
  end

  def create
    result = GSituacoesPredios::CreateService.call(params: g_situacao_predio_params)
    render ResponseService.handle_service_result(result, blueprint: GSituacaoPredioBlueprint)
  end

  def update
    result = GSituacoesPredios::UpdateService.call(g_situacao_predio: @g_situacao_predio, params: g_situacao_predio_params)
    render ResponseService.handle_service_result(result, blueprint: GSituacaoPredioBlueprint)
  end

  def destroy
    result = GSituacoesPredios::DestroyService.call(g_situacao_predio: @g_situacao_predio)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_situacao_predio
    @g_situacao_predio = GSituacaoPredio.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GSituacaoPredio.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_situacao_predio_params
    params.require(:g_situacao_predio).permit(*PERMITTED_ATTRIBUTES)
  end
end
