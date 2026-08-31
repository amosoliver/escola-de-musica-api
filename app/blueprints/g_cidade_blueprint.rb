# frozen_string_literal: true

class GCidadeBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :uf, :codigo_ibge
  association :g_estado, blueprint: GEstadoBlueprint
  association :g_pais, blueprint: GPaisBlueprint
end
