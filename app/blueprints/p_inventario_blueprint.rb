# frozen_string_literal: true

class PInventarioBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :data_inicio, :data_fim, :encerrado, :observacao
  association :i_predio, blueprint: IPredioSummaryBlueprint
  association :i_bloco, blueprint: IBlocoSummaryBlueprint
  association :i_ambiente_predial, blueprint: IAmbientePredialBlueprint
  association :r_funcionario_responsavel, blueprint: RFuncionarioSummaryBlueprint
end
