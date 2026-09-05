# frozen_string_literal: true

class Api::V1::PInventariosController < ApplicationController
  include Pagy::Method

  before_action :set_p_inventario, only: %i[show encerrar]

  def index
    query = scoped_p_inventarios.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PInventarioBlueprint)
  end

  def show
    render ResponseService.success(data: @p_inventario, message: "Inventario encontrado com sucesso", blueprint: PInventarioBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(create_params)
    return if performed?

    result = PInventarios::CreateService.call(g_unidade_gestora_id: attributes[:g_unidade_gestora_id], params: attributes)
    render ResponseService.handle_service_result(result, blueprint: PInventarioBlueprint)
  end

  # POST /p_inventarios/:id/encerrar
  def encerrar
    result = PInventarios::EncerrarService.call(p_inventario: @p_inventario)
    render ResponseService.handle_service_result(result, blueprint: PInventarioBlueprint)
  end

  private

  def set_p_inventario
    @p_inventario = scoped_p_inventarios.find(params[:id])
  end

  def index_associations
    [ :i_predio, :i_bloco, :i_ambiente_predial, { r_funcionario_responsavel: :g_pessoa } ]
  end

  def scoped_p_inventarios
    tenant_scope(PInventario.all)
  end

  def create_params
    params.permit(
      :g_unidade_gestora_id, :descricao, :r_funcionario_responsavel_id,
      :i_predio_id, :i_bloco_id, :i_ambiente_predial_id, :data_inicio, :observacao
    ).to_h.deep_symbolize_keys
  end
end
