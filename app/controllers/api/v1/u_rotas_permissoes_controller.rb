# frozen_string_literal: true

class Api::V1::URotasPermissoesController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :u_rota_id,
    :u_permissao_id,
  ].freeze

  before_action :set_u_rota_permissao, only: %i[show update destroy]

  def index
    query = URotaPermissao.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: URotaPermissaoBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_rota_permissao,
      message: "U rota permissao encontrado com sucesso",
      blueprint: URotaPermissaoBlueprint
    )
  end

  def create
    result = URotasPermissoes::CreateService.call(params: u_rota_permissao_params)
    render ResponseService.handle_service_result(result, blueprint: URotaPermissaoBlueprint)
  end

  def update
    result = URotasPermissoes::UpdateService.call(u_rota_permissao: @u_rota_permissao, params: u_rota_permissao_params)
    render ResponseService.handle_service_result(result, blueprint: URotaPermissaoBlueprint)
  end

  def destroy
    result = URotasPermissoes::DestroyService.call(u_rota_permissao: @u_rota_permissao)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_rota_permissao
    @u_rota_permissao = URotaPermissao.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= URotaPermissao.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_rota_permissao_params
    params.require(:u_rota_permissao).permit(*PERMITTED_ATTRIBUTES)
  end
end
