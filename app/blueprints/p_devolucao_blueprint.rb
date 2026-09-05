# frozen_string_literal: true

class PDevolucaoBlueprint < ApplicationBlueprint
  identifier :id
  fields :data_devolucao, :observacao
  association :p_emprestimo, blueprint: PEmprestimoBlueprint
  association :r_funcionario_recebimento, blueprint: RFuncionarioSummaryBlueprint
  association :p_devolucoes_itens, blueprint: PDevolucaoItemBlueprint
end
