# frozen_string_literal: true

class Api::V1::GParentescosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[descricao permite_outro].freeze

  before_action :set_g_parentesco, only: %i[show update destroy]

  def index
    query = GParentesco.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GParentescoBlueprint)
  end

  def show
    render ResponseService.success(data: @g_parentesco, message: "Parentesco encontrado com sucesso", blueprint: GParentescoBlueprint)
  end

  def create
    result = GParentescos::CreateService.call(params: g_parentesco_params)
    render ResponseService.handle_service_result(result, blueprint: GParentescoBlueprint)
  end

  def update
    result = GParentescos::UpdateService.call(g_parentesco: @g_parentesco, params: g_parentesco_params)
    render ResponseService.handle_service_result(result, blueprint: GParentescoBlueprint)
  end

  def destroy
    result = GParentescos::DestroyService.call(g_parentesco: @g_parentesco)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_parentesco
    @g_parentesco = GParentesco.find(params[:id])
  end

  def g_parentesco_params
    params.require(:g_parentesco).permit(*PERMITTED_ATTRIBUTES)
  end
end
