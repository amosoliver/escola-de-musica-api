# frozen_string_literal: true

class URotaBlueprint < ApplicationBlueprint
  identifier :id
  fields :descricao, :nome_rota, :path, :componente, :metodo, :requer_autorizacao, :ativo
end
