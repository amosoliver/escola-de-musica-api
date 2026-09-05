# frozen_string_literal: true

class Api::V1::PDevolucoesController < ApplicationController
  include Pagy::Method

  ITEM_ATTRIBUTES = %i[p_emprestimo_item_id p_estado_conservacao_patrimonio_id possui_avaria descricao_avaria observacao].freeze

  before_action :set_p_emprestimo
  before_action :set_p_devolucao, only: :show

  def index
    query = @p_emprestimo.p_devolucoes.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PDevolucaoBlueprint)
  end

  def show
    render ResponseService.success(data: @p_devolucao, message: "Devolucao encontrada com sucesso", blueprint: PDevolucaoBlueprint)
  end

  def create
    result = PDevolucoes::CreateService.call(p_emprestimo: @p_emprestimo, params: create_params)
    render ResponseService.handle_service_result(result, blueprint: PDevolucaoBlueprint)
  end

  private

  def set_p_emprestimo
    @p_emprestimo = tenant_scope(PEmprestimo.all).find(params[:p_emprestimo_id])
  end

  def set_p_devolucao
    @p_devolucao = @p_emprestimo.p_devolucoes.find(params[:id])
  end

  def index_associations
    [ { r_funcionario_recebimento: :g_pessoa }, { p_devolucoes_itens: { p_emprestimo_item: :p_patrimonio } } ]
  end

  def create_params
    params.permit(
      :r_funcionario_recebimento_id, :data_devolucao, :observacao,
      p_devolucoes_itens_attributes: ITEM_ATTRIBUTES
    ).to_h.deep_symbolize_keys
  end
end
