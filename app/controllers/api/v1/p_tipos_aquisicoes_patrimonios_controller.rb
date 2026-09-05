# frozen_string_literal: true

class Api::V1::PTiposAquisicoesPatrimoniosController < ApplicationController
  include Pagy::Method
  PERMITTED_ATTRIBUTES = %i[codigo descricao ativo].freeze
  before_action :set_record, only: %i[show update destroy]

  def index
    render ResponseService.pagy_index(PTipoAquisicaoPatrimonio.ransack(params[:q]).result, params, self, blueprint: PTipoAquisicaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @record, message: "Tipo de aquisicao do patrimonio encontrado com sucesso", blueprint: PTipoAquisicaoPatrimonioBlueprint)
  end

  def create
    render ResponseService.handle_service_result(PTiposAquisicoesPatrimonios::CreateService.call(params: resource_params), blueprint: PTipoAquisicaoPatrimonioBlueprint)
  end

  def update
    result = PTiposAquisicoesPatrimonios::UpdateService.call(record: @record, params: resource_params)
    render ResponseService.handle_service_result(result, blueprint: PTipoAquisicaoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PTiposAquisicoesPatrimonios::DestroyService.call(record: @record))
  end

  private

  def set_record = @record = PTipoAquisicaoPatrimonio.find(params[:id])
  def resource_params = params.require(:p_tipo_aquisicao_patrimonio).permit(*PERMITTED_ATTRIBUTES)
end
