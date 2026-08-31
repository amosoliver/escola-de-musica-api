# frozen_string_literal: true

class Api::V1::RTiposVinculosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[descricao codigo ativo].freeze

  before_action :set_r_tipo_vinculo, only: %i[show update destroy]

  def index
    query = RTipoVinculo.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: RTipoVinculoBlueprint)
  end

  def show
    render ResponseService.success(data: @r_tipo_vinculo, message: "Tipo de vinculo encontrado com sucesso", blueprint: RTipoVinculoBlueprint)
  end

  def create
    result = RTiposVinculos::CreateService.call(params: r_tipo_vinculo_params)
    render ResponseService.handle_service_result(result, blueprint: RTipoVinculoBlueprint)
  end

  def update
    result = RTiposVinculos::UpdateService.call(r_tipo_vinculo: @r_tipo_vinculo, params: r_tipo_vinculo_params)
    render ResponseService.handle_service_result(result, blueprint: RTipoVinculoBlueprint)
  end

  def destroy
    result = RTiposVinculos::DestroyService.call(r_tipo_vinculo: @r_tipo_vinculo)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_r_tipo_vinculo
    @r_tipo_vinculo = RTipoVinculo.find(params[:id])
  end

  def r_tipo_vinculo_params
    params.require(:r_tipo_vinculo).permit(*PERMITTED_ATTRIBUTES)
  end
end
