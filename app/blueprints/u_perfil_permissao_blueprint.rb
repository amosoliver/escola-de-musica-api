# frozen_string_literal: true

class UPerfilPermissaoBlueprint < ApplicationBlueprint
  identifier :id
  association :u_perfil, blueprint: UPerfilBlueprint
  association :u_permissao, blueprint: UPermissaoBlueprint
end
