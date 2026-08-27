# frozen_string_literal: true

class Api::V1::UsersPerfisController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :user_id,
    :u_perfil_id,
    :g_unidade_gestora_id,
    :ativo,
  ].freeze

  before_action :set_user_perfil, only: %i[show update destroy]

  def index
    query = UserPerfil.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: UserPerfilBlueprint)
  end

  def show
    render ResponseService.success(
      data: @user_perfil,
      message: "User perfil encontrado com sucesso",
      blueprint: UserPerfilBlueprint
    )
  end

  def create
    result = UsersPerfis::CreateService.call(params: user_perfil_params)
    render ResponseService.handle_service_result(result, blueprint: UserPerfilBlueprint)
  end

  def update
    result = UsersPerfis::UpdateService.call(user_perfil: @user_perfil, params: user_perfil_params)
    render ResponseService.handle_service_result(result, blueprint: UserPerfilBlueprint)
  end

  def destroy
    result = UsersPerfis::DestroyService.call(user_perfil: @user_perfil)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_user_perfil
    @user_perfil = UserPerfil.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= UserPerfil.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def user_perfil_params
    params.require(:user_perfil).permit(*PERMITTED_ATTRIBUTES)
  end
end
