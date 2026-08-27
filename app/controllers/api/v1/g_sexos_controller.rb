# frozen_string_literal: true

class Api::V1::GSexosController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :descricao,
  ].freeze

  before_action :set_g_sexo, only: %i[show update destroy]

  def index
    query = GSexo.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GSexoBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_sexo,
      message: "G sexo encontrado com sucesso",
      blueprint: GSexoBlueprint
    )
  end

  def create
    result = GSexos::CreateService.call(params: g_sexo_params)
    render ResponseService.handle_service_result(result, blueprint: GSexoBlueprint)
  end

  def update
    result = GSexos::UpdateService.call(g_sexo: @g_sexo, params: g_sexo_params)
    render ResponseService.handle_service_result(result, blueprint: GSexoBlueprint)
  end

  def destroy
    result = GSexos::DestroyService.call(g_sexo: @g_sexo)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_sexo
    @g_sexo = GSexo.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GSexo.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_sexo_params
    params.require(:g_sexo).permit(*PERMITTED_ATTRIBUTES)
  end
end
