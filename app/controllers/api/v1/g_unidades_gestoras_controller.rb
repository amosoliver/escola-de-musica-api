# frozen_string_literal: true

class Api::V1::GUnidadesGestorasController < ApplicationController
  include Pagy::Method
  include TenantScoped

  PERMITTED_ATTRIBUTES = [
    :g_unidade_gestora_id,
    :g_tipo_unidade_gestora_id,
    :tipo_unidade,
    :nome,
    :razao_social,
    :nome_fantasia,
    :cnpj,
    :logo,
    :telefone,
    :whatsapp,
    :email,
    :site,
    :responsavel_nome,
    :status,
    :identidade_visual,
    {
      g_unidade_gestora_responsavel_attributes: [
        :id,
        :g_pessoa_id,
        :atualizar_g_pessoa,
        :r_funcao_id,
        :u_perfil_id,
        :principal,
        :data_inicio,
        :data_fim,
        :ativo,
        {
          g_pessoa_attributes: Api::V1::GPessoasController::PERMITTED_ATTRIBUTES - %i[u_perfil_id g_unidade_gestora_id ativo]
        }
      ]
    }
  ].freeze

  before_action :authorize_admin_plataforma!, only: %i[create destroy]
  before_action :set_g_unidade_gestora, only: %i[show update destroy]

  def index
    query = scoped_g_unidades_gestoras.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GUnidadeGestoraBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_unidade_gestora,
      message: "Unidade gestora encontrada com sucesso",
      blueprint: GUnidadeGestoraBlueprint
    )
  end

  def create
    result = GUnidadesGestoras::CreateService.call(params: g_unidade_gestora_params)
    render ResponseService.handle_service_result(result, blueprint: GUnidadeGestoraBlueprint)
  end

  def update
    result = GUnidadesGestoras::UpdateService.call(g_unidade_gestora: @g_unidade_gestora, params: g_unidade_gestora_params)
    render ResponseService.handle_service_result(result, blueprint: GUnidadeGestoraBlueprint)
  end

  def destroy
    result = GUnidadesGestoras::DestroyService.call(g_unidade_gestora: @g_unidade_gestora)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_unidade_gestora
    @g_unidade_gestora = scoped_g_unidades_gestoras.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GUnidadeGestora.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def scoped_g_unidades_gestoras
    tenant_scope(GUnidadeGestora.all)
  end

  def g_unidade_gestora_params
    params.require(:g_unidade_gestora).permit(*PERMITTED_ATTRIBUTES)
  end
end
