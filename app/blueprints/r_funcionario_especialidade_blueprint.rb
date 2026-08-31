# frozen_string_literal: true

class RFuncionarioEspecialidadeBlueprint < ApplicationBlueprint
  identifier :id
  fields :principal, :data_inicio, :data_fim, :ativo
  association :r_especialidade, blueprint: REspecialidadeBlueprint
end
