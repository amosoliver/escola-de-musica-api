# frozen_string_literal: true

class Api::V1::GCategoriasPatrimoniosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[codigo descricao ativo].freeze

  before_action :set_g_categoria_patrimonio, only: %i[show update destroy]

  def index
    query = GCategoriaPatrimonio.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GCategoriaPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @g_categoria_patrimonio, message: "Categoria patrimonial encontrada com sucesso", blueprint: GCategoriaPatrimonioBlueprint)
  end

  def create
    result = GCategoriasPatrimonios::CreateService.call(params: g_categoria_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: GCategoriaPatrimonioBlueprint)
  end

  def update
    result = GCategoriasPatrimonios::UpdateService.call(g_categoria_patrimonio: @g_categoria_patrimonio, params: g_categoria_patrimonio_params)
    render ResponseService.handle_service_result(result, blueprint: GCategoriaPatrimonioBlueprint)
  end

  def destroy
    result = GCategoriasPatrimonios::DestroyService.call(g_categoria_patrimonio: @g_categoria_patrimonio)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_categoria_patrimonio
    @g_categoria_patrimonio = GCategoriaPatrimonio.find(params[:id])
  end

  def g_categoria_patrimonio_params
    params.require(:g_categoria_patrimonio).permit(*PERMITTED_ATTRIBUTES)
  end
end
