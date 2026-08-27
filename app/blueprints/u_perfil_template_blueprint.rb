# frozen_string_literal: true

class UPerfilTemplateBlueprint < ApplicationBlueprint
  identifier :id
  fields :principal, :ativo
  association :u_perfil, blueprint: UPerfilBlueprint
  association :u_template, blueprint: UTemplateBlueprint
end
