# frozen_string_literal: true

class Api::V1::GClassificacoesInstrumentosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[codigo descricao ativo].freeze

  before_action :set_g_classificacao_instrumento, only: %i[show update destroy]

  def index
    query = GClassificacaoInstrumento.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GClassificacaoInstrumentoBlueprint)
  end

  def show
    render ResponseService.success(data: @g_classificacao_instrumento, message: "Classificacao de instrumento encontrada com sucesso", blueprint: GClassificacaoInstrumentoBlueprint)
  end

  def create
    result = GClassificacoesInstrumentos::CreateService.call(params: g_classificacao_instrumento_params)
    render ResponseService.handle_service_result(result, blueprint: GClassificacaoInstrumentoBlueprint)
  end

  def update
    result = GClassificacoesInstrumentos::UpdateService.call(g_classificacao_instrumento: @g_classificacao_instrumento, params: g_classificacao_instrumento_params)
    render ResponseService.handle_service_result(result, blueprint: GClassificacaoInstrumentoBlueprint)
  end

  def destroy
    result = GClassificacoesInstrumentos::DestroyService.call(g_classificacao_instrumento: @g_classificacao_instrumento)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_classificacao_instrumento
    @g_classificacao_instrumento = GClassificacaoInstrumento.find(params[:id])
  end

  def g_classificacao_instrumento_params
    params.require(:g_classificacao_instrumento).permit(*PERMITTED_ATTRIBUTES)
  end
end
