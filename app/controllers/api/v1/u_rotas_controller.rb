# frozen_string_literal: true

class Api::V1::URotasController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :descricao,
    :nome_rota,
    :path,
    :componente,
    :metodo,
    :requer_autorizacao,
    :ativo,
  ].freeze

  before_action :set_u_rota, only: %i[show update destroy]

  def index
    query = URota.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: URotaBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_rota,
      message: "U rota encontrado com sucesso",
      blueprint: URotaBlueprint
    )
  end

  def create
    result = URotas::CreateService.call(params: u_rota_params)
    render ResponseService.handle_service_result(result, blueprint: URotaBlueprint)
  end

  def update
    result = URotas::UpdateService.call(u_rota: @u_rota, params: u_rota_params)
    render ResponseService.handle_service_result(result, blueprint: URotaBlueprint)
  end

  def destroy
    result = URotas::DestroyService.call(u_rota: @u_rota)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_rota
    @u_rota = URota.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= URota.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_rota_params
    params.require(:u_rota).permit(*PERMITTED_ATTRIBUTES)
  end
end
