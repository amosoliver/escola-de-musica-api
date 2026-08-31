# frozen_string_literal: true

class RFuncaoBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :codigo, :ativo
  association :r_funcoes_perfis, blueprint: RFuncaoPerfilBlueprint
end
