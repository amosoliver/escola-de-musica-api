# frozen_string_literal: true

class Api::V1::GUnidadesGestorasController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :g_unidade_gestora_id,
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
  ].freeze

  before_action :set_g_unidade_gestora, only: %i[show update destroy]

  def index
    query = GUnidadeGestora.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GUnidadeGestoraBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_unidade_gestora,
      message: "G unidade gestora encontrado com sucesso",
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
    @g_unidade_gestora = GUnidadeGestora.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GUnidadeGestora.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_unidade_gestora_params
    params.require(:g_unidade_gestora).permit(*PERMITTED_ATTRIBUTES)
  end
end
