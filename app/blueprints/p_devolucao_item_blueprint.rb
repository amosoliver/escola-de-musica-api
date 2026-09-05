# frozen_string_literal: true

class PDevolucaoItemBlueprint < ApplicationBlueprint
  identifier :id
  fields :possui_avaria, :descricao_avaria, :observacao
  association :p_emprestimo_item, blueprint: PEmprestimoItemBlueprint
  association :p_estado_conservacao_patrimonio, blueprint: PEstadoConservacaoPatrimonioBlueprint
end
