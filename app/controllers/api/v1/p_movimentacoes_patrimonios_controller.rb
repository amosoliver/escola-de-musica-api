# frozen_string_literal: true

# Historico de movimentacoes de patrimonio (somente leitura). Os registros sao
# criados pelos fluxos especificos: PPatrimoniosController#transferir/vender/
# doar/descartar e Api::V1::PManutencoesPatrimoniosController.
class Api::V1::PMovimentacoesPatrimoniosController < ApplicationController
  include Pagy::Method

  before_action :set_p_movimentacao_patrimonio, only: :show

  def index
    query = scoped_p_movimentacoes.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PMovimentacaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @p_movimentacao_patrimonio, message: "Movimentacao encontrada com sucesso", blueprint: PMovimentacaoPatrimonioBlueprint)
  end

  private

  def set_p_movimentacao_patrimonio
    @p_movimentacao_patrimonio = scoped_p_movimentacoes.find(params[:id])
  end

  def index_associations
    [
      :p_patrimonio, :p_tipo_movimentacao_patrimonio, :i_ambiente_predial_origem,
      :i_ambiente_predial_destino, :p_destino_externo, { r_funcionario: :g_pessoa }
    ]
  end

  def scoped_p_movimentacoes
    tenant_scope(PMovimentacaoPatrimonio.all)
  end
end
