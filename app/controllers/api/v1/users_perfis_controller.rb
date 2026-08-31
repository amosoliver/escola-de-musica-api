# frozen_string_literal: true

class Api::V1::UsersPerfisController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :user_id,
    :u_perfil_id,
    :g_unidade_gestora_id,
    :ativo,
  ].freeze

  before_action :set_user_perfil, only: %i[show update destroy]

  def index
    query = scoped_users_perfis.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: UserPerfilBlueprint)
  end

  def show
    render ResponseService.success(
      data: @user_perfil,
      message: "Perfil de usuario encontrado com sucesso",
      blueprint: UserPerfilBlueprint
    )
  end

  def create
    attributes = enforce_tenant_attribute!(user_perfil_params.to_h.deep_symbolize_keys)
    return if performed?

    result = UsersPerfis::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: UserPerfilBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(user_perfil_params.to_h.deep_symbolize_keys)
    return if performed?

    result = UsersPerfis::UpdateService.call(user_perfil: @user_perfil, params: attributes)
    render ResponseService.handle_service_result(result, blueprint: UserPerfilBlueprint)
  end

  def destroy
    result = UsersPerfis::DestroyService.call(user_perfil: @user_perfil)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_user_perfil
    @user_perfil = scoped_users_perfis.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= UserPerfil.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def scoped_users_perfis
    tenant_scope(UserPerfil.all)
  end

  def user_perfil_params
    params.require(:user_perfil).permit(*PERMITTED_ATTRIBUTES)
  end
end
