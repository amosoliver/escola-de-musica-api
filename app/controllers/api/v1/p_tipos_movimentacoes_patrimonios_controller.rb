# frozen_string_literal: true

class Api::V1::PTiposMovimentacoesPatrimoniosController < ApplicationController
  include Pagy::Method
  PERMITTED_ATTRIBUTES = %i[codigo descricao destino_interno destino_externo movimentacao_definitiva ativo].freeze
  before_action :set_record, only: %i[show update destroy]

  def index
    render ResponseService.pagy_index(PTipoMovimentacaoPatrimonio.ransack(params[:q]).result, params, self, blueprint: PTipoMovimentacaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @record, message: "Tipo de movimentacao do patrimonio encontrado com sucesso", blueprint: PTipoMovimentacaoPatrimonioBlueprint)
  end

  def create
    render ResponseService.handle_service_result(PTiposMovimentacoesPatrimonios::CreateService.call(params: resource_params), blueprint: PTipoMovimentacaoPatrimonioBlueprint)
  end

  def update
    result = PTiposMovimentacoesPatrimonios::UpdateService.call(record: @record, params: resource_params)
    render ResponseService.handle_service_result(result, blueprint: PTipoMovimentacaoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PTiposMovimentacoesPatrimonios::DestroyService.call(record: @record))
  end

  private

  def set_record = @record = PTipoMovimentacaoPatrimonio.find(params[:id])
  def resource_params = params.require(:p_tipo_movimentacao_patrimonio).permit(*PERMITTED_ATTRIBUTES)
end
