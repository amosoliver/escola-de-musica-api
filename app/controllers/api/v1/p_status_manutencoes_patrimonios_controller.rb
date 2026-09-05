# frozen_string_literal: true

class Api::V1::PStatusManutencoesPatrimoniosController < ApplicationController
  include Pagy::Method
  PERMITTED_ATTRIBUTES = %i[codigo descricao finalizador ativo].freeze
  before_action :set_record, only: %i[show update destroy]

  def index
    render ResponseService.pagy_index(PStatusManutencaoPatrimonio.ransack(params[:q]).result, params, self, blueprint: PStatusManutencaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @record, message: "Status de manutencao do patrimonio encontrado com sucesso", blueprint: PStatusManutencaoPatrimonioBlueprint)
  end

  def create
    render ResponseService.handle_service_result(PStatusManutencoesPatrimonios::CreateService.call(params: resource_params), blueprint: PStatusManutencaoPatrimonioBlueprint)
  end

  def update
    result = PStatusManutencoesPatrimonios::UpdateService.call(record: @record, params: resource_params)
    render ResponseService.handle_service_result(result, blueprint: PStatusManutencaoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PStatusManutencoesPatrimonios::DestroyService.call(record: @record))
  end

  private

  def set_record = @record = PStatusManutencaoPatrimonio.find(params[:id])
  def resource_params = params.require(:p_status_manutencao_patrimonio).permit(*PERMITTED_ATTRIBUTES)
end
