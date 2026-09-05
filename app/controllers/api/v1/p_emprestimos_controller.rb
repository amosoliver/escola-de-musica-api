# frozen_string_literal: true

class Api::V1::PEmprestimosController < ApplicationController
  include Pagy::Method

  ITEM_ATTRIBUTES = %i[p_patrimonio_id p_estado_conservacao_patrimonio_id observacao_entrega].freeze

  before_action :set_p_emprestimo, only: :show

  def index
    query = scoped_p_emprestimos.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PEmprestimoBlueprint)
  end

  def show
    render ResponseService.success(data: @p_emprestimo, message: "Emprestimo encontrado com sucesso", blueprint: PEmprestimoBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(create_params)
    return if performed?

    result = PEmprestimos::CreateService.call(g_unidade_gestora_id: attributes[:g_unidade_gestora_id], params: attributes)
    render ResponseService.handle_service_result(result, blueprint: PEmprestimoBlueprint)
  end

  private

  def set_p_emprestimo
    @p_emprestimo = scoped_p_emprestimos.find(params[:id])
  end

  def index_associations
    [
      :g_pessoa, :p_status_emprestimo_patrimonio, { r_funcionario_entrega: :g_pessoa },
      { p_emprestimos_itens: :p_patrimonio }
    ]
  end

  def scoped_p_emprestimos
    tenant_scope(PEmprestimo.all)
  end

  def create_params
    params.permit(
      :g_unidade_gestora_id, :g_pessoa_id, :r_funcionario_entrega_id, :numero_emprestimo,
      :data_emprestimo, :data_prevista_devolucao, :observacao,
      p_emprestimos_itens_attributes: ITEM_ATTRIBUTES
    ).to_h.deep_symbolize_keys
  end
end
