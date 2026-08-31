# frozen_string_literal: true

class Api::V1::RFuncoesController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :descricao,
    :codigo,
    :ativo,
    r_funcoes_perfis_attributes: %i[id u_perfil_id principal ativo _destroy]
  ].freeze

  before_action :set_r_funcao, only: %i[show update destroy]

  def index
    query = RFuncao.includes(r_funcoes_perfis: :u_perfil).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: RFuncaoBlueprint)
  end

  def show
    render ResponseService.success(data: @r_funcao, message: "Funcao encontrada com sucesso", blueprint: RFuncaoBlueprint)
  end

  def create
    result = RFuncoes::CreateService.call(params: r_funcao_params.to_h.deep_symbolize_keys)
    render ResponseService.handle_service_result(result, blueprint: RFuncaoBlueprint)
  end

  def update
    result = RFuncoes::UpdateService.call(r_funcao: @r_funcao, params: r_funcao_params.to_h.deep_symbolize_keys)
    render ResponseService.handle_service_result(result, blueprint: RFuncaoBlueprint)
  end

  def destroy
    result = RFuncoes::DestroyService.call(r_funcao: @r_funcao)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_r_funcao
    @r_funcao = RFuncao.find(params[:id])
  end

  def r_funcao_params
    params.require(:r_funcao).permit(*PERMITTED_ATTRIBUTES)
  end
end
