# frozen_string_literal: true

class Api::V1::PTiposManutencoesPatrimoniosController < ApplicationController
  include Pagy::Method
  PERMITTED_ATTRIBUTES = %i[codigo descricao ativo].freeze
  before_action :set_record, only: %i[show update destroy]

  def index
    render ResponseService.pagy_index(PTipoManutencaoPatrimonio.ransack(params[:q]).result, params, self, blueprint: PTipoManutencaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @record, message: "Tipo de manutencao do patrimonio encontrado com sucesso", blueprint: PTipoManutencaoPatrimonioBlueprint)
  end

  def create
    render ResponseService.handle_service_result(PTiposManutencoesPatrimonios::CreateService.call(params: resource_params), blueprint: PTipoManutencaoPatrimonioBlueprint)
  end

  def update
    result = PTiposManutencoesPatrimonios::UpdateService.call(record: @record, params: resource_params)
    render ResponseService.handle_service_result(result, blueprint: PTipoManutencaoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PTiposManutencoesPatrimonios::DestroyService.call(record: @record))
  end

  private

  def set_record = @record = PTipoManutencaoPatrimonio.find(params[:id])
  def resource_params = params.require(:p_tipo_manutencao_patrimonio).permit(*PERMITTED_ATTRIBUTES)
end
