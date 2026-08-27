# frozen_string_literal: true

class Api::V1::GCidadesController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :g_pais_id,
    :g_estado_id,
    :descricao,
    :uf,
    :codigo_ibge,
  ].freeze

  before_action :set_g_cidade, only: %i[show update destroy]

  def index
    query = GCidade.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GCidadeBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_cidade,
      message: "G cidade encontrado com sucesso",
      blueprint: GCidadeBlueprint
    )
  end

  def create
    result = GCidades::CreateService.call(params: g_cidade_params)
    render ResponseService.handle_service_result(result, blueprint: GCidadeBlueprint)
  end

  def update
    result = GCidades::UpdateService.call(g_cidade: @g_cidade, params: g_cidade_params)
    render ResponseService.handle_service_result(result, blueprint: GCidadeBlueprint)
  end

  def destroy
    result = GCidades::DestroyService.call(g_cidade: @g_cidade)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_cidade
    @g_cidade = GCidade.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GCidade.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_cidade_params
    params.require(:g_cidade).permit(*PERMITTED_ATTRIBUTES)
  end
end
