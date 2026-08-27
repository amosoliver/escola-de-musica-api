# frozen_string_literal: true

class IBlocoBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :ativo
  association :i_predio, blueprint: IPredioBlueprint
  association :g_andar, blueprint: GAndarBlueprint
end
