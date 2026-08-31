# frozen_string_literal: true

class IBlocoBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :ativo
  association :i_predio, blueprint: IPredioSummaryBlueprint
  association :g_andar, blueprint: GAndarBlueprint
  association :g_unidade_gestora, blueprint: GUnidadeGestoraSummaryBlueprint
end
