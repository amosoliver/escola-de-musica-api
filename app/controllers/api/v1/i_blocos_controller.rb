# frozen_string_literal: true

class Api::V1::IBlocosController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :i_predio_id,
    :g_andar_id,
    :descricao,
    :ativo
  ].freeze

  before_action :set_i_bloco, only: %i[show update destroy]

  def index
    query = IBloco.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: IBlocoBlueprint)
  end

  def show
    render ResponseService.success(
      data: @i_bloco,
      message: "I bloco encontrado com sucesso",
      blueprint: IBlocoBlueprint
    )
  end

  def create
    result = IBlocos::CreateService.call(params: i_bloco_params)
    render ResponseService.handle_service_result(result, blueprint: IBlocoBlueprint)
  end

  def update
    result = IBlocos::UpdateService.call(i_bloco: @i_bloco, params: i_bloco_params)
    render ResponseService.handle_service_result(result, blueprint: IBlocoBlueprint)
  end

  def destroy
    result = IBlocos::DestroyService.call(i_bloco: @i_bloco)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_i_bloco
    @i_bloco = IBloco.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= IBloco.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def i_bloco_params
    params.require(:i_bloco).permit(*PERMITTED_ATTRIBUTES)
  end
end
