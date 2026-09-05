# frozen_string_literal: true

# Historico de baixas de patrimonio (somente leitura). Os registros sao criados
# pelos endpoints especificos PPatrimoniosController#vender/doar/descartar.
class Api::V1::PBaixasPatrimoniosController < ApplicationController
  include Pagy::Method

  before_action :set_p_baixa_patrimonio, only: :show

  def index
    query = scoped_p_baixas.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PBaixaPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @p_baixa_patrimonio, message: "Baixa encontrada com sucesso", blueprint: PBaixaPatrimonioBlueprint)
  end

  private

  def set_p_baixa_patrimonio
    @p_baixa_patrimonio = scoped_p_baixas.find(params[:id])
  end

  def index_associations
    [ :p_patrimonio, :p_tipo_baixa_patrimonio, :p_destino_externo, { r_funcionario: :g_pessoa } ]
  end

  def scoped_p_baixas
    tenant_scope(PBaixaPatrimonio.all)
  end
end
