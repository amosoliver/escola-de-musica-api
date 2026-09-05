# frozen_string_literal: true

class PMovimentacaoPatrimonioBlueprint < ApplicationBlueprint
  identifier :id
  fields :data_hora, :motivo, :observacao
  association :p_patrimonio, blueprint: PPatrimonioSummaryBlueprint
  association :p_tipo_movimentacao_patrimonio, blueprint: PTipoMovimentacaoPatrimonioBlueprint
  association :i_ambiente_predial_origem, blueprint: IAmbientePredialBlueprint
  association :i_ambiente_predial_destino, blueprint: IAmbientePredialBlueprint
  association :p_destino_externo, blueprint: PDestinoExternoSummaryBlueprint
  association :r_funcionario, blueprint: RFuncionarioSummaryBlueprint
end
