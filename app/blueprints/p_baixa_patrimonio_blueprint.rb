# frozen_string_literal: true

class PBaixaPatrimonioBlueprint < ApplicationBlueprint
  identifier :id
  fields :data_baixa, :valor, :documento, :numero_documento, :justificativa, :observacao
  association :p_patrimonio, blueprint: PPatrimonioSummaryBlueprint
  association :p_tipo_baixa_patrimonio, blueprint: PTipoBaixaPatrimonioBlueprint
  association :p_destino_externo, blueprint: PDestinoExternoSummaryBlueprint
  association :r_funcionario, blueprint: RFuncionarioSummaryBlueprint
end
