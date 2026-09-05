# frozen_string_literal: true

class Api::V1::GInstrumentosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[g_tipo_instrumento_id codigo descricao ativo].freeze

  before_action :set_g_instrumento, only: %i[show update destroy]

  def index
    query = GInstrumento.includes(g_tipo_instrumento: :g_classificacao_instrumento).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GInstrumentoBlueprint)
  end

  def show
    render ResponseService.success(data: @g_instrumento, message: "Instrumento encontrado com sucesso", blueprint: GInstrumentoBlueprint)
  end

  def create
    result = GInstrumentos::CreateService.call(params: g_instrumento_params)
    render ResponseService.handle_service_result(result, blueprint: GInstrumentoBlueprint)
  end

  def update
    result = GInstrumentos::UpdateService.call(g_instrumento: @g_instrumento, params: g_instrumento_params)
    render ResponseService.handle_service_result(result, blueprint: GInstrumentoBlueprint)
  end

  def destroy
    result = GInstrumentos::DestroyService.call(g_instrumento: @g_instrumento)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_instrumento
    @g_instrumento = GInstrumento.find(params[:id])
  end

  def g_instrumento_params
    params.require(:g_instrumento).permit(*PERMITTED_ATTRIBUTES)
  end
end
