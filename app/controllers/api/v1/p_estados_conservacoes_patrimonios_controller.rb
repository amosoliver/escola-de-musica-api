# frozen_string_literal: true

class Api::V1::PEstadosConservacoesPatrimoniosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[codigo descricao ordem ativo].freeze

  before_action :set_p_estado_conservacao_patrimonio, only: %i[show update destroy]

  def index
    query = PEstadoConservacaoPatrimonio.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PEstadoConservacaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @p_estado_conservacao_patrimonio, message: "Estado de conservacao do patrimonio encontrado com sucesso", blueprint: PEstadoConservacaoPatrimonioBlueprint)
  end

  def create
    result = PEstadosConservacoesPatrimonios::CreateService.call(params: p_estado_conservacao_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: PEstadoConservacaoPatrimonioBlueprint)
  end

  def update
    result = PEstadosConservacoesPatrimonios::UpdateService.call(record: @p_estado_conservacao_patrimonio, params: p_estado_conservacao_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: PEstadoConservacaoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PEstadosConservacoesPatrimonios::DestroyService.call(record: @p_estado_conservacao_patrimonio))
  end

  private

  def set_p_estado_conservacao_patrimonio
    @p_estado_conservacao_patrimonio = PEstadoConservacaoPatrimonio.find(params[:id])
  end

  def p_estado_conservacao_patrimonio_params
    params.require(:p_estado_conservacao_patrimonio).permit(*PERMITTED_ATTRIBUTES)
  end
end
