# frozen_string_literal: true

class RFuncionarioFuncaoBlueprint < ApplicationBlueprint
  identifier :id
  fields :principal, :data_inicio, :data_fim, :ativo
  association :r_funcao, blueprint: RFuncaoBlueprint
end
