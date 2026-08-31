# frozen_string_literal: true

class Api::V1::UPerfisController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :descricao,
    :codigo,
    :ativo,
  ].freeze

  before_action :set_u_perfil, only: %i[show update destroy]

  def index
    query = UPerfil.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: UPerfilBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_perfil,
      message: "Perfil encontrado com sucesso",
      blueprint: UPerfilBlueprint
    )
  end

  def create
    result = UPerfis::CreateService.call(params: u_perfil_params)
    render ResponseService.handle_service_result(result, blueprint: UPerfilBlueprint)
  end

  def update
    result = UPerfis::UpdateService.call(u_perfil: @u_perfil, params: u_perfil_params)
    render ResponseService.handle_service_result(result, blueprint: UPerfilBlueprint)
  end

  def destroy
    result = UPerfis::DestroyService.call(u_perfil: @u_perfil)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_perfil
    @u_perfil = UPerfil.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= UPerfil.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_perfil_params
    params.require(:u_perfil).permit(*PERMITTED_ATTRIBUTES)
  end
end
