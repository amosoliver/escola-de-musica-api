# frozen_string_literal: true

class Api::V1::UTemplatesController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :descricao,
    :chave,
    :componente_layout,
    :configuracao,
    :ativo,
  ].freeze

  before_action :set_u_template, only: %i[show update destroy]

  def index
    query = UTemplate.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: UTemplateBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_template,
      message: "Template encontrado com sucesso",
      blueprint: UTemplateBlueprint
    )
  end

  def create
    result = UTemplates::CreateService.call(params: u_template_params)
    render ResponseService.handle_service_result(result, blueprint: UTemplateBlueprint)
  end

  def update
    result = UTemplates::UpdateService.call(u_template: @u_template, params: u_template_params)
    render ResponseService.handle_service_result(result, blueprint: UTemplateBlueprint)
  end

  def destroy
    result = UTemplates::DestroyService.call(u_template: @u_template)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_template
    @u_template = UTemplate.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= UTemplate.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_template_params
    params.require(:u_template).permit(*PERMITTED_ATTRIBUTES)
  end
end
