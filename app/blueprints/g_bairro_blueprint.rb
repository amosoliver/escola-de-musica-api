# frozen_string_literal: true

class GBairroBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :codigo_ibge
  association :g_cidade, blueprint: GCidadeBlueprint
end
