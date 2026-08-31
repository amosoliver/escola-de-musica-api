# frozen_string_literal: true

class Api::V1::UPerfisTemplatesController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :u_perfil_id,
    :u_template_id,
    :principal,
    :ativo,
  ].freeze

  before_action :set_u_perfil_template, only: %i[show update destroy]

  def index
    query = UPerfilTemplate.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: UPerfilTemplateBlueprint)
  end

  def show
    render ResponseService.success(
      data: @u_perfil_template,
      message: "Perfil template encontrado com sucesso",
      blueprint: UPerfilTemplateBlueprint
    )
  end

  def create
    result = UPerfisTemplates::CreateService.call(params: u_perfil_template_params)
    render ResponseService.handle_service_result(result, blueprint: UPerfilTemplateBlueprint)
  end

  def update
    result = UPerfisTemplates::UpdateService.call(u_perfil_template: @u_perfil_template, params: u_perfil_template_params)
    render ResponseService.handle_service_result(result, blueprint: UPerfilTemplateBlueprint)
  end

  def destroy
    result = UPerfisTemplates::DestroyService.call(u_perfil_template: @u_perfil_template)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_u_perfil_template
    @u_perfil_template = UPerfilTemplate.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= UPerfilTemplate.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def u_perfil_template_params
    params.require(:u_perfil_template).permit(*PERMITTED_ATTRIBUTES)
  end
end
