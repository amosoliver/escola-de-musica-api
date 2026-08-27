# frozen_string_literal: true

class GEstadoBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :uf, :codigo_ibge
  association :g_pais, blueprint: GPaisBlueprint
end
