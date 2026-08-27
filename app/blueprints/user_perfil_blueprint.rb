# frozen_string_literal: true

class UserPerfilBlueprint < ApplicationBlueprint
  identifier :id
  fields :ativo
  association :user, blueprint: UserBlueprint
  association :u_perfil, blueprint: UPerfilBlueprint
  association :g_unidade_gestora, blueprint: GUnidadeGestoraBlueprint
end
