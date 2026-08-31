# frozen_string_literal: true

class Api::V1::IPrediosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :g_unidade_gestora_id,
    :g_tipo_predio_id,
    :g_situacao_predio_id,
    :nome,
    :latitude,
    :longitude,
    :cep,
    :logradouro,
    :g_bairro_id,
    :numero,
    :complemento,
    :g_cidade_id,
    :telefone_contato,
    :email_responsavel,
    :data_inicio,
    :data_fim,
    :principal,
    :ativo
  ].freeze

  before_action :set_i_predio, only: %i[show update destroy]

  def index
    query = scoped_i_predios.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: IPredioBlueprint)
  end

  def show
    render ResponseService.success(
      data: @i_predio,
      message: "Predio encontrado com sucesso",
      blueprint: IPredioBlueprint
    )
  end

  def create
    attributes = enforce_tenant_attribute!(i_predio_params.to_h.deep_symbolize_keys)
    return if performed?

    result = IPredios::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: IPredioBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(i_predio_params.to_h.deep_symbolize_keys)
    return if performed?

    result = IPredios::UpdateService.call(i_predio: @i_predio, params: attributes)
    render ResponseService.handle_service_result(result, blueprint: IPredioBlueprint)
  end

  def destroy
    result = IPredios::DestroyService.call(i_predio: @i_predio)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_i_predio
    @i_predio = scoped_i_predios.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= IPredio.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def scoped_i_predios
    tenant_scope(IPredio.all)
  end

  def i_predio_params
    params.require(:i_predio).permit(*PERMITTED_ATTRIBUTES)
  end
end
