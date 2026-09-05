# frozen_string_literal: true

class Api::V1::PPatrimoniosArquivosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[p_tipo_arquivo_patrimonio_id arquivo nome_original content_type tamanho_bytes observacao].freeze

  before_action :set_p_patrimonio
  before_action :set_p_patrimonio_arquivo, only: :destroy

  def index
    query = @p_patrimonio.p_patrimonios_arquivos.includes(:p_tipo_arquivo_patrimonio).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PPatrimonioArquivoBlueprint)
  end

  def create
    result = PPatrimoniosArquivos::CreateService.call(p_patrimonio: @p_patrimonio, params: p_patrimonio_arquivo_params)
    render ResponseService.handle_service_result(result, blueprint: PPatrimonioArquivoBlueprint)
  end

  def destroy
    result = PPatrimoniosArquivos::DestroyService.call(p_patrimonio_arquivo: @p_patrimonio_arquivo)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_p_patrimonio
    @p_patrimonio = tenant_scope(PPatrimonio.all).find(params[:p_patrimonio_id])
  end

  def set_p_patrimonio_arquivo
    @p_patrimonio_arquivo = @p_patrimonio.p_patrimonios_arquivos.find(params[:id])
  end

  def p_patrimonio_arquivo_params
    params.require(:p_patrimonio_arquivo).permit(*PERMITTED_ATTRIBUTES).to_h.symbolize_keys
  end
end
