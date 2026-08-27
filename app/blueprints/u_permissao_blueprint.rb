# frozen_string_literal: true

class UPermissaoBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :codigo, :modulo, :acao, :ativo
end
