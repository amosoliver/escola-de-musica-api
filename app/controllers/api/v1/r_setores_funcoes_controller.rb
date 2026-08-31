# frozen_string_literal: true

class Api::V1::RSetoresFuncoesController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[r_setor_id r_funcao_id principal ativo].freeze

  before_action :set_r_setor_funcao, only: %i[show update destroy]

  def index
    query = scoped_r_setores_funcoes.includes(:r_setor, :r_funcao).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: RSetorFuncaoBlueprint)
  end

  def show
    render ResponseService.success(
      data: @r_setor_funcao,
      message: "Vinculo setor-funcao encontrado com sucesso",
      blueprint: RSetorFuncaoBlueprint
    )
  end

  def create
    if r_setor_funcao_params[:r_setor_id].present?
      scoped_setores = tenant_scope(RSetor.all)
      return if performed?

      scoped_setores.find(r_setor_funcao_params[:r_setor_id])
    end

    result = RSetoresFuncoes::CreateService.call(params: r_setor_funcao_params.to_h.deep_symbolize_keys)
    render ResponseService.handle_service_result(result, blueprint: RSetorFuncaoBlueprint)
  end

  def update
    if r_setor_funcao_params[:r_setor_id].present?
      scoped_setores = tenant_scope(RSetor.all)
      return if performed?

      scoped_setores.find(r_setor_funcao_params[:r_setor_id])
    end

    result = RSetoresFuncoes::UpdateService.call(
      r_setor_funcao: @r_setor_funcao,
      params: r_setor_funcao_params.to_h.deep_symbolize_keys
    )
    render ResponseService.handle_service_result(result, blueprint: RSetorFuncaoBlueprint)
  end

  def destroy
    result = RSetoresFuncoes::DestroyService.call(r_setor_funcao: @r_setor_funcao)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_r_setor_funcao
    @r_setor_funcao = scoped_r_setores_funcoes.find(params[:id])
  end

  def scoped_r_setores_funcoes
    tenant_scope(RSetorFuncao.joins(:r_setor), column: "r_setores.g_unidade_gestora_id")
  end

  def r_setor_funcao_params
    params.require(:r_setor_funcao).permit(*PERMITTED_ATTRIBUTES)
  end
end
