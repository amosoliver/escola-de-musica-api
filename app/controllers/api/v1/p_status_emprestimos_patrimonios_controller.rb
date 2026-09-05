# frozen_string_literal: true

class Api::V1::PStatusEmprestimosPatrimoniosController < ApplicationController
  include Pagy::Method
  PERMITTED_ATTRIBUTES = %i[codigo descricao finalizador ativo].freeze
  before_action :set_record, only: %i[show update destroy]

  def index
    render ResponseService.pagy_index(PStatusEmprestimoPatrimonio.ransack(params[:q]).result, params, self, blueprint: PStatusEmprestimoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @record, message: "Status de emprestimo do patrimonio encontrado com sucesso", blueprint: PStatusEmprestimoPatrimonioBlueprint)
  end

  def create
    render ResponseService.handle_service_result(PStatusEmprestimosPatrimonios::CreateService.call(params: resource_params), blueprint: PStatusEmprestimoPatrimonioBlueprint)
  end

  def update
    result = PStatusEmprestimosPatrimonios::UpdateService.call(record: @record, params: resource_params)
    render ResponseService.handle_service_result(result, blueprint: PStatusEmprestimoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PStatusEmprestimosPatrimonios::DestroyService.call(record: @record))
  end

  private

  def set_record = @record = PStatusEmprestimoPatrimonio.find(params[:id])
  def resource_params = params.require(:p_status_emprestimo_patrimonio).permit(*PERMITTED_ATTRIBUTES)
end
