# frozen_string_literal: true

class PEmprestimoItemBlueprint < ApplicationBlueprint
  identifier :id
  fields :observacao_entrega
  association :p_patrimonio, blueprint: PPatrimonioSummaryBlueprint
  association :p_estado_conservacao_patrimonio, blueprint: PEstadoConservacaoPatrimonioBlueprint
  field :devolvido do |item|
    item.devolvido?
  end
end
