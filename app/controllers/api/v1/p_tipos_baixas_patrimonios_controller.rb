# frozen_string_literal: true

class Api::V1::PTiposBaixasPatrimoniosController < ApplicationController
  include Pagy::Method
  PERMITTED_ATTRIBUTES = %i[codigo descricao ativo].freeze
  before_action :set_record, only: %i[show update destroy]

  def index
    render ResponseService.pagy_index(PTipoBaixaPatrimonio.ransack(params[:q]).result, params, self, blueprint: PTipoBaixaPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @record, message: "Tipo de baixa do patrimonio encontrado com sucesso", blueprint: PTipoBaixaPatrimonioBlueprint)
  end

  def create
    render ResponseService.handle_service_result(PTiposBaixasPatrimonios::CreateService.call(params: resource_params), blueprint: PTipoBaixaPatrimonioBlueprint)
  end

  def update
    result = PTiposBaixasPatrimonios::UpdateService.call(record: @record, params: resource_params)
    render ResponseService.handle_service_result(result, blueprint: PTipoBaixaPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PTiposBaixasPatrimonios::DestroyService.call(record: @record))
  end

  private

  def set_record = @record = PTipoBaixaPatrimonio.find(params[:id])
  def resource_params = params.require(:p_tipo_baixa_patrimonio).permit(*PERMITTED_ATTRIBUTES)
end
