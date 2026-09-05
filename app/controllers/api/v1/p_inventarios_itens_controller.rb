# frozen_string_literal: true

class Api::V1::PInventariosItensController < ApplicationController
  include Pagy::Method

  before_action :set_p_inventario
  before_action :set_p_inventario_item, only: :update

  def index
    query = @p_inventario.p_inventarios_itens.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PInventarioItemBlueprint)
  end

  def update
    result = PInventariosItens::ConferirService.call(p_inventario_item: @p_inventario_item, params: conferir_params)
    render ResponseService.handle_service_result(result, blueprint: PInventarioItemBlueprint)
  end

  private

  def set_p_inventario
    @p_inventario = tenant_scope(PInventario.all).find(params[:p_inventario_id])
  end

  def set_p_inventario_item
    @p_inventario_item = @p_inventario.p_inventarios_itens.find(params[:id])
  end

  def index_associations
    [ :p_patrimonio, :i_ambiente_predial_encontrado, :p_estado_conservacao_patrimonio ]
  end

  def conferir_params
    params.permit(
      :encontrado, :i_ambiente_predial_encontrado_id, :p_estado_conservacao_patrimonio_id, :observacao
    ).to_h.deep_symbolize_keys
  end
end
