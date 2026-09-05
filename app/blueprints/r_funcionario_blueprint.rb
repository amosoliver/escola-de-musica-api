# frozen_string_literal: true

class RFuncionarioBlueprint < ApplicationBlueprint
  identifier :id
  fields :matricula, :data_inicio, :data_fim, :ativo
  association :g_pessoa, blueprint: GPessoaBlueprint
  association :g_unidade_gestora, blueprint: GUnidadeGestoraSummaryBlueprint
  association :r_tipo_vinculo, blueprint: RTipoVinculoBlueprint
  association :r_funcionarios_especialidades, blueprint: RFuncionarioEspecialidadeBlueprint
  association :r_funcionarios_setores_funcoes, blueprint: RFuncionarioSetorFuncaoBlueprint
end
