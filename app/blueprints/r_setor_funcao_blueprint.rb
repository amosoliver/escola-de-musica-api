# frozen_string_literal: true

class RSetorFuncaoBlueprint < ApplicationBlueprint
  identifier :id
  fields :principal, :ativo
  association :r_setor, blueprint: RSetorSummaryBlueprint
  association :r_funcao, blueprint: RFuncaoBlueprint
end
