# frozen_string_literal: true

class Api::V1::IPrediosController < ApplicationController
  include Pagy::Backend

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
    :g_pais_id,
    :telefone_contato,
    :email_responsavel,
    :data_inicio,
    :data_fim,
    :principal,
    :ativo
  ].freeze

  before_action :set_i_predio, only: %i[show update destroy]

  def index
    query = IPredio.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: IPredioBlueprint)
  end

  def show
    render ResponseService.success(
      data: @i_predio,
      message: "I predio encontrado com sucesso",
      blueprint: IPredioBlueprint
    )
  end

  def create
    result = IPredios::CreateService.call(params: i_predio_params)
    render ResponseService.handle_service_result(result, blueprint: IPredioBlueprint)
  end

  def update
    result = IPredios::UpdateService.call(i_predio: @i_predio, params: i_predio_params)
    render ResponseService.handle_service_result(result, blueprint: IPredioBlueprint)
  end

  def destroy
    result = IPredios::DestroyService.call(i_predio: @i_predio)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_i_predio
    @i_predio = IPredio.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= IPredio.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def i_predio_params
    params.require(:i_predio).permit(*PERMITTED_ATTRIBUTES)
  end
end
