# frozen_string_literal: true

class RFuncionarioSetorFuncaoBlueprint < ApplicationBlueprint
  identifier :id
  fields :principal, :data_inicio, :data_fim, :ativo
  association :r_setor_funcao, blueprint: RSetorFuncaoBlueprint
end
