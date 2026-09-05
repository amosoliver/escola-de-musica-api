# frozen_string_literal: true

class Api::V1::PSituacoesPatrimoniosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[codigo descricao permite_emprestimo permite_movimentacao ativo].freeze

  before_action :set_p_situacao_patrimonio, only: %i[show update destroy]

  def index
    query = PSituacaoPatrimonio.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PSituacaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @p_situacao_patrimonio, message: "Situacao de patrimonio encontrada com sucesso", blueprint: PSituacaoPatrimonioBlueprint)
  end

  def create
    result = PSituacoesPatrimonios::CreateService.call(params: p_situacao_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: PSituacaoPatrimonioBlueprint)
  end

  def update
    result = PSituacoesPatrimonios::UpdateService.call(record: @p_situacao_patrimonio, params: p_situacao_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: PSituacaoPatrimonioBlueprint)
  end

  def destroy
    render ResponseService.handle_service_result(PSituacoesPatrimonios::DestroyService.call(record: @p_situacao_patrimonio))
  end

  private

  def set_p_situacao_patrimonio
    @p_situacao_patrimonio = PSituacaoPatrimonio.find(params[:id])
  end

  def p_situacao_patrimonio_params
    params.require(:p_situacao_patrimonio).permit(*PERMITTED_ATTRIBUTES)
  end
end
