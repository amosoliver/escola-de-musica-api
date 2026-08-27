# frozen_string_literal: true

class USidebarBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :chave, :posicao, :ativo
  association :u_template, blueprint: UTemplateBlueprint
end
