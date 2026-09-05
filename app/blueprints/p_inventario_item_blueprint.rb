# frozen_string_literal: true

class PInventarioItemBlueprint < ApplicationBlueprint
  identifier :id
  fields :encontrado, :localizacao_divergente, :conferido_em, :observacao
  association :p_patrimonio, blueprint: PPatrimonioSummaryBlueprint
  association :i_ambiente_predial_encontrado, blueprint: IAmbientePredialBlueprint
  association :p_estado_conservacao_patrimonio, blueprint: PEstadoConservacaoPatrimonioBlueprint
end
