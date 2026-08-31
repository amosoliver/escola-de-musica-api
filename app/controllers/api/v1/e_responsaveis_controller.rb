# frozen_string_literal: true

class Api::V1::EResponsaveisController < ApplicationController
  include Pagy::Method

  G_PESSOA_ATTRIBUTES = Api::V1::GPessoasController::PERMITTED_ATTRIBUTES - %i[
    password
    password_confirmation
    u_perfil_id
    g_unidade_gestora_id
    ativo
  ]

  PERMITTED_ATTRIBUTES = [
    :g_pessoa_id,
    :atualizar_g_pessoa,
    :g_unidade_gestora_id,
    :ativo,
    g_pessoa_attributes: G_PESSOA_ATTRIBUTES
  ].freeze

  before_action :set_e_responsavel, only: %i[show update destroy]

  def index
    query = scoped_e_responsaveis.includes(:g_pessoa, :g_unidade_gestora).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: EResponsavelBlueprint)
  end

  def show
    render ResponseService.success(data: @e_responsavel, message: "Responsavel encontrado com sucesso", blueprint: EResponsavelBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(e_responsavel_params.to_h.deep_symbolize_keys)
    return if performed?

    result = EResponsaveis::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: EResponsavelBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(e_responsavel_params.to_h.deep_symbolize_keys)
    return if performed?

    result = EResponsaveis::UpdateService.call(
      e_responsavel: @e_responsavel,
      params: attributes
    )
    render ResponseService.handle_service_result(result, blueprint: EResponsavelBlueprint)
  end

  def destroy
    result = EResponsaveis::DestroyService.call(e_responsavel: @e_responsavel)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_e_responsavel
    @e_responsavel = scoped_e_responsaveis.find(params[:id])
  end

  def scoped_e_responsaveis
    tenant_scope(EResponsavel.all)
  end

  def e_responsavel_params
    params.require(:e_responsavel).permit(*PERMITTED_ATTRIBUTES)
  end
end
