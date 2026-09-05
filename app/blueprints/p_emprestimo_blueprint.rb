# frozen_string_literal: true

class PEmprestimoBlueprint < ApplicationBlueprint
  identifier :id
  fields :numero_emprestimo, :data_emprestimo, :data_prevista_devolucao, :observacao
  association :g_pessoa, blueprint: GPessoaBlueprint
  association :p_status_emprestimo_patrimonio, blueprint: PStatusEmprestimoPatrimonioBlueprint
  association :r_funcionario_entrega, blueprint: RFuncionarioSummaryBlueprint
  association :p_emprestimos_itens, blueprint: PEmprestimoItemBlueprint
end
