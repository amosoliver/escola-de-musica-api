# frozen_string_literal: true

class Api::V1::PDestinosExternosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[
    g_unidade_gestora_id g_bairro_id nome razao_social cpf_cnpj email telefone
    cep logradouro numero complemento observacao ativo
  ].freeze

  before_action :set_p_destino_externo, only: %i[show update destroy]

  def index
    query = scoped_p_destinos_externos.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PDestinoExternoBlueprint)
  end

  def show
    render ResponseService.success(data: @p_destino_externo, message: "Destino externo encontrado com sucesso", blueprint: PDestinoExternoBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(p_destino_externo_params.to_h.deep_symbolize_keys)
    return if performed?

    result = PDestinosExternos::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: PDestinoExternoBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(p_destino_externo_params.to_h.deep_symbolize_keys)
    return if performed?

    result = PDestinosExternos::UpdateService.call(p_destino_externo: @p_destino_externo, params: attributes)
    render ResponseService.handle_service_result(result, blueprint: PDestinoExternoBlueprint)
  end

  def destroy
    result = PDestinosExternos::DestroyService.call(p_destino_externo: @p_destino_externo)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_p_destino_externo
    @p_destino_externo = scoped_p_destinos_externos.find(params[:id])
  end

  def scoped_p_destinos_externos
    tenant_scope(PDestinoExterno.all)
  end

  def p_destino_externo_params
    params.require(:p_destino_externo).permit(*PERMITTED_ATTRIBUTES)
  end
end
