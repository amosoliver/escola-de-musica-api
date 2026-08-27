# frozen_string_literal: true

class Api::V1::UPerfisPermissoesController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :u_perfil_id,
    :u_permissao_id,
  ].freeze

  before_action :set_u_perfil_permissao, only: %i[show update destroy]

  def index
    query = UPerfilPermissao.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: UPerfilPermissaoBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_perfil_permissao,
      message: "U perfil permissao encontrado com sucesso",
      blueprint: UPerfilPermissaoBlueprint
    )
  end

  def create
    result = UPerfisPermissoes::CreateService.call(params: u_perfil_permissao_params)
    render ResponseService.handle_service_result(result, blueprint: UPerfilPermissaoBlueprint)
  end

  def update
    result = UPerfisPermissoes::UpdateService.call(u_perfil_permissao: @u_perfil_permissao, params: u_perfil_permissao_params)
    render ResponseService.handle_service_result(result, blueprint: UPerfilPermissaoBlueprint)
  end

  def destroy
    result = UPerfisPermissoes::DestroyService.call(u_perfil_permissao: @u_perfil_permissao)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_perfil_permissao
    @u_perfil_permissao = UPerfilPermissao.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= UPerfilPermissao.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_perfil_permissao_params
    params.require(:u_perfil_permissao).permit(*PERMITTED_ATTRIBUTES)
  end
end
