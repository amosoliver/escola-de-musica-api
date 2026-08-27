# frozen_string_literal: true

class Api::V1::UPermissoesController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :descricao,
    :codigo,
    :modulo,
    :acao,
    :ativo,
  ].freeze

  before_action :set_u_permissao, only: %i[show update destroy]

  def index
    query = UPermissao.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: UPermissaoBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_permissao,
      message: "U permissao encontrado com sucesso",
      blueprint: UPermissaoBlueprint
    )
  end

  def create
    result = UPermissoes::CreateService.call(params: u_permissao_params)
    render ResponseService.handle_service_result(result, blueprint: UPermissaoBlueprint)
  end

  def update
    result = UPermissoes::UpdateService.call(u_permissao: @u_permissao, params: u_permissao_params)
    render ResponseService.handle_service_result(result, blueprint: UPermissaoBlueprint)
  end

  def destroy
    result = UPermissoes::DestroyService.call(u_permissao: @u_permissao)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_permissao
    @u_permissao = UPermissao.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= UPermissao.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_permissao_params
    params.require(:u_permissao).permit(*PERMITTED_ATTRIBUTES)
  end
end
