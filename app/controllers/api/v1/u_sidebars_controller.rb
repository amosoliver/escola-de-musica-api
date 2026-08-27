# frozen_string_literal: true

class Api::V1::USidebarsController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :u_template_id,
    :descricao,
    :chave,
    :posicao,
    :ativo,
  ].freeze

  before_action :set_u_sidebar, only: %i[show update destroy]

  def index
    query = USidebar.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: USidebarBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_sidebar,
      message: "U sidebar encontrado com sucesso",
      blueprint: USidebarBlueprint
    )
  end

  def create
    result = USidebars::CreateService.call(params: u_sidebar_params)
    render ResponseService.handle_service_result(result, blueprint: USidebarBlueprint)
  end

  def update
    result = USidebars::UpdateService.call(u_sidebar: @u_sidebar, params: u_sidebar_params)
    render ResponseService.handle_service_result(result, blueprint: USidebarBlueprint)
  end

  def destroy
    result = USidebars::DestroyService.call(u_sidebar: @u_sidebar)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_sidebar
    @u_sidebar = USidebar.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= USidebar.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_sidebar_params
    params.require(:u_sidebar).permit(*PERMITTED_ATTRIBUTES)
  end
end
