# frozen_string_literal: true

class GTipoPatrimonioBlueprint < ApplicationBlueprint
  identifier :id
  fields :codigo, :descricao, :representa_instrumento, :ativo
  association :g_categoria_patrimonio, blueprint: GCategoriaPatrimonioBlueprint
end
