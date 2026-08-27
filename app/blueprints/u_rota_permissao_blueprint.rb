# frozen_string_literal: true

class URotaPermissaoBlueprint < ApplicationBlueprint
  identifier :id
  association :u_rota, blueprint: URotaBlueprint
  association :u_permissao, blueprint: UPermissaoBlueprint
end
