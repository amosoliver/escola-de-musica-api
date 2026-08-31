# frozen_string_literal: true

class Api::V1::REspecialidadesController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[descricao codigo ativo].freeze

  before_action :set_r_especialidade, only: %i[show update destroy]

  def index
    query = REspecialidade.ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: REspecialidadeBlueprint)
  end

  def show
    render ResponseService.success(data: @r_especialidade, message: "Especialidade encontrada com sucesso", blueprint: REspecialidadeBlueprint)
  end

  def create
    result = REspecialidades::CreateService.call(params: r_especialidade_params)
    render ResponseService.handle_service_result(result, blueprint: REspecialidadeBlueprint)
  end

  def update
    result = REspecialidades::UpdateService.call(r_especialidade: @r_especialidade, params: r_especialidade_params)
    render ResponseService.handle_service_result(result, blueprint: REspecialidadeBlueprint)
  end

  def destroy
    result = REspecialidades::DestroyService.call(r_especialidade: @r_especialidade)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_r_especialidade
    @r_especialidade = REspecialidade.find(params[:id])
  end

  def r_especialidade_params
    params.require(:r_especialidade).permit(*PERMITTED_ATTRIBUTES)
  end
end
