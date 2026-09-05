# frozen_string_literal: true

class PManutencaoPatrimonioBlueprint < ApplicationBlueprint
  identifier :id
  fields :data_solicitacao, :data_prevista, :data_inicio, :data_conclusao,
         :descricao_problema, :descricao_servico, :valor_estimado, :valor_realizado, :observacao
  association :p_patrimonio, blueprint: PPatrimonioSummaryBlueprint
  association :p_tipo_manutencao_patrimonio, blueprint: PTipoManutencaoPatrimonioBlueprint
  association :p_status_manutencao_patrimonio, blueprint: PStatusManutencaoPatrimonioBlueprint
  association :p_destino_externo, blueprint: PDestinoExternoSummaryBlueprint
  association :r_funcionario_solicitante, blueprint: RFuncionarioSummaryBlueprint
end
