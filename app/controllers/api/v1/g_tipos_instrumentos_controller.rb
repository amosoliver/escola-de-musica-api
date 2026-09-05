# frozen_string_literal: true

class Api::V1::GTiposInstrumentosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[g_classificacao_instrumento_id codigo descricao ativo].freeze

  before_action :set_g_tipo_instrumento, only: %i[show update destroy]

  def index
    query = GTipoInstrumento.includes(:g_classificacao_instrumento).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GTipoInstrumentoBlueprint)
  end

  def show
    render ResponseService.success(data: @g_tipo_instrumento, message: "Tipo de instrumento encontrado com sucesso", blueprint: GTipoInstrumentoBlueprint)
  end

  def create
    result = GTiposInstrumentos::CreateService.call(params: g_tipo_instrumento_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoInstrumentoBlueprint)
  end

  def update
    result = GTiposInstrumentos::UpdateService.call(g_tipo_instrumento: @g_tipo_instrumento, params: g_tipo_instrumento_params)
    render ResponseService.handle_service_result(result, blueprint: GTipoInstrumentoBlueprint)
  end

  def destroy
    result = GTiposInstrumentos::DestroyService.call(g_tipo_instrumento: @g_tipo_instrumento)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_tipo_instrumento
    @g_tipo_instrumento = GTipoInstrumento.find(params[:id])
  end

  def g_tipo_instrumento_params
    params.require(:g_tipo_instrumento).permit(*PERMITTED_ATTRIBUTES)
  end
end
