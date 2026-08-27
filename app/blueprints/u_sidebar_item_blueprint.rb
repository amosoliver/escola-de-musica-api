# frozen_string_literal: true

class USidebarItemBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :icone, :tipo, :ordem, :expandido_padrao, :ativo
  association :u_sidebar, blueprint: USidebarBlueprint
  association :u_sidebar_item_pai, blueprint: USidebarItemBlueprint
  association :u_rota, blueprint: URotaBlueprint
end
