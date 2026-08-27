# frozen_string_literal: true

class Api::V1::GBairrosController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :g_cidade_id,
    :descricao,
    :codigo_ibge,
  ].freeze

  before_action :set_g_bairro, only: %i[show update destroy]

  def index
    query = GBairro.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GBairroBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_bairro,
      message: "G bairro encontrado com sucesso",
      blueprint: GBairroBlueprint
    )
  end

  def create
    result = GBairros::CreateService.call(params: g_bairro_params)
    render ResponseService.handle_service_result(result, blueprint: GBairroBlueprint)
  end

  def update
    result = GBairros::UpdateService.call(g_bairro: @g_bairro, params: g_bairro_params)
    render ResponseService.handle_service_result(result, blueprint: GBairroBlueprint)
  end

  def destroy
    result = GBairros::DestroyService.call(g_bairro: @g_bairro)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_bairro
    @g_bairro = GBairro.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GBairro.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_bairro_params
    params.require(:g_bairro).permit(*PERMITTED_ATTRIBUTES)
  end
end
