# frozen_string_literal: true

class Api::V1::IBlocosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :i_predio_id,
    :g_andar_id,
    :descricao,
    :ativo
  ].freeze

  before_action :set_i_bloco, only: %i[show update destroy]

  def index
    query = scoped_i_blocos.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: IBlocoBlueprint)
  end

  def show
    render ResponseService.success(
      data: @i_bloco,
      message: "Bloco encontrado com sucesso",
      blueprint: IBlocoBlueprint
    )
  end

  def create
    result = IBlocos::CreateService.call(params: scoped_i_bloco_params)
    render ResponseService.handle_service_result(result, blueprint: IBlocoBlueprint)
  end

  def update
    result = IBlocos::UpdateService.call(i_bloco: @i_bloco, params: scoped_i_bloco_params)
    render ResponseService.handle_service_result(result, blueprint: IBlocoBlueprint)
  end

  def destroy
    result = IBlocos::DestroyService.call(i_bloco: @i_bloco)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_i_bloco
    @i_bloco = scoped_i_blocos.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= IBloco.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def scoped_i_blocos
    scoped = tenant_scope(IBloco.all)
    return scoped.merge(IBlocos::PorPredioEAndarQuery.call(i_predio_id: params[:i_predio_id], g_andar_id: params[:g_andar_id])) if nested_predio_andar?

    scoped
  end

  def scoped_i_bloco_params
    i_bloco_params.to_h.symbolize_keys.tap do |attributes|
      attributes[:i_predio_id] = params[:i_predio_id] if params[:i_predio_id].present?
      attributes[:g_andar_id] = params[:g_andar_id] if params[:g_andar_id].present?
      next unless attributes[:i_predio_id].present?

      scoped_predios = tenant_scope(IPredio.all)
      next if performed?

      scoped_predios.find(attributes[:i_predio_id])
    end
  end

  def nested_predio_andar?
    params[:i_predio_id].present? && params[:g_andar_id].present?
  end

  def i_bloco_params
    params.require(:i_bloco).permit(*PERMITTED_ATTRIBUTES)
  end
end
