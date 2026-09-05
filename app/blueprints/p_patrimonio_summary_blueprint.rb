# frozen_string_literal: true

class PPatrimonioSummaryBlueprint < ApplicationBlueprint
  identifier :id
  fields :codigo_patrimonial, :descricao, :marca, :modelo, :numero_serie, :ativo
  association :p_situacao_patrimonio, blueprint: PSituacaoPatrimonioBlueprint
  association :p_estado_conservacao_patrimonio, blueprint: PEstadoConservacaoPatrimonioBlueprint
end
