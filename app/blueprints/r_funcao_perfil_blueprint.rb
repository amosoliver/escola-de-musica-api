# frozen_string_literal: true

class RFuncaoPerfilBlueprint < ApplicationBlueprint
  identifier :id
  fields :principal, :ativo
  association :u_perfil, blueprint: UPerfilBlueprint
end
