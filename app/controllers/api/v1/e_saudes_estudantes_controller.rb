# frozen_string_literal: true

class Api::V1::ESaudesEstudantesController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :e_estudante_id,
    :observacoes_gerais,
    e_saudes_estudantes_alergias_attributes: %i[id g_alergia_id observacao ativo _destroy],
    e_saudes_estudantes_necessidades_attributes: %i[
      id
      g_necessidade_especifica_id
      observacao
      laudo_arquivo
      data_laudo
      ativo
      _destroy
    ]
  ].freeze

  before_action :set_e_saude_estudante, only: %i[show update destroy]

  def index
    query = scoped_e_saudes_estudantes.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: ESaudeEstudanteBlueprint)
  end

  def show
    render ResponseService.success(
      data: @e_saude_estudante,
      message: "Saude do estudante encontrada com sucesso",
      blueprint: ESaudeEstudanteBlueprint
    )
  end

  def create
    if e_saude_estudante_params[:e_estudante_id].present?
      scoped_estudantes = scoped_e_estudantes
      return if performed?

      scoped_estudantes.find(e_saude_estudante_params[:e_estudante_id])
    end

    result = ESaudesEstudantes::CreateService.call(params: e_saude_estudante_params.to_h.deep_symbolize_keys)
    render ResponseService.handle_service_result(result, blueprint: ESaudeEstudanteBlueprint)
  end

  def update
    if e_saude_estudante_params[:e_estudante_id].present?
      scoped_estudantes = scoped_e_estudantes
      return if performed?

      scoped_estudantes.find(e_saude_estudante_params[:e_estudante_id])
    end

    result = ESaudesEstudantes::UpdateService.call(
      e_saude_estudante: @e_saude_estudante,
      params: e_saude_estudante_params.to_h.deep_symbolize_keys
    )
    render ResponseService.handle_service_result(result, blueprint: ESaudeEstudanteBlueprint)
  end

  def destroy
    result = ESaudesEstudantes::DestroyService.call(e_saude_estudante: @e_saude_estudante)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_e_saude_estudante
    @e_saude_estudante = scoped_e_saudes_estudantes.find(params[:id])
  end

  def index_associations
    [
      :e_estudante,
      { e_saudes_estudantes_alergias: :g_alergia },
      { e_saudes_estudantes_necessidades: :g_necessidade_especifica }
    ]
  end

  def scoped_e_saudes_estudantes
    tenant_scope(ESaudeEstudante.joins(:e_estudante), column: "e_estudantes.g_unidade_gestora_id")
  end

  def e_saude_estudante_params
    params.require(:e_saude_estudante).permit(*PERMITTED_ATTRIBUTES)
  end
end
