# frozen_string_literal: true

class Api::V1::PTiposArquivosPatrimoniosController < ApplicationController
  include Pagy::Method
  PERMITTED_ATTRIBUTES = %i[codigo descricao ativo].freeze
  before_action :set_record, only: %i[show update destroy]

  def index
    render ResponseService.pagy_index(PTipoArquivoPatrimonio.ransack(params[:q]).result, params, self, blueprint: PTipoArquivoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @record, message: "Tipo de arquivo do patrimonio encontrado com sucesso", blueprint: PTipoArquivoPatrimonioBlueprint)
  end

  def create
    render ResponseService.handle_service_result(PTiposArquivosPatrimonios::CreateService.call(params: resource_params), blueprint: PTipoArquivoPatrimonioBlueprint)
  end

  def update
    result = PTiposArquivosPatrimonios::UpdateService.call(record: @record, params: resource_params)
    render ResponseService.handle_service_result(result, blueprint: PTipoArquivoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PTiposArquivosPatrimonios::DestroyService.call(record: @record))
  end

  private

  def set_record = @record = PTipoArquivoPatrimonio.find(params[:id])
  def resource_params = params.require(:p_tipo_arquivo_patrimonio).permit(*PERMITTED_ATTRIBUTES)
end
