# frozen_string_literal: true

class Api::V1::USidebarItensController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :u_sidebar_id,
    :u_sidebar_item_pai_id,
    :u_rota_id,
    :descricao,
    :icone,
    :tipo,
    :ordem,
    :expandido_padrao,
    :ativo,
  ].freeze

  before_action :set_u_sidebar_item, only: %i[show update destroy]

  def index
    query = USidebarItem.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: USidebarItemBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_sidebar_item,
      message: "U sidebar item encontrado com sucesso",
      blueprint: USidebarItemBlueprint
    )
  end

  def create
    result = USidebarItens::CreateService.call(params: u_sidebar_item_params)
    render ResponseService.handle_service_result(result, blueprint: USidebarItemBlueprint)
  end

  def update
    result = USidebarItens::UpdateService.call(u_sidebar_item: @u_sidebar_item, params: u_sidebar_item_params)
    render ResponseService.handle_service_result(result, blueprint: USidebarItemBlueprint)
  end

  def destroy
    result = USidebarItens::DestroyService.call(u_sidebar_item: @u_sidebar_item)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_sidebar_item
    @u_sidebar_item = USidebarItem.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= USidebarItem.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_sidebar_item_params
    params.require(:u_sidebar_item).permit(*PERMITTED_ATTRIBUTES)
  end
end
