# frozen_string_literal: true

class IAmbientePredialBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :comprimento, :largura, :metros_quadrados, :capacidade, :permite_reserva, :ativo
  association :i_bloco, blueprint: IBlocoBlueprint
  association :g_tipo_ambiente_predial, blueprint: GTipoAmbientePredialBlueprint
end
