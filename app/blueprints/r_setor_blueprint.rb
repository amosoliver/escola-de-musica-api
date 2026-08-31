# frozen_string_literal: true

class RSetorBlueprint < ApplicationBlueprint
  identifier :id
  fields :codigo, :descricao, :ordem, :ativo
  association :g_unidade_gestora, blueprint: GUnidadeGestoraSummaryBlueprint
  association :r_setor_pai, blueprint: RSetorSummaryBlueprint
  association :r_setores_filhos, blueprint: RSetorSummaryBlueprint
  association :r_setores_funcoes, blueprint: RSetorFuncaoBlueprint
end
