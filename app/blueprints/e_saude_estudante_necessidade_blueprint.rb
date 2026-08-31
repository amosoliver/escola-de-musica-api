# frozen_string_literal: true

class ESaudeEstudanteNecessidadeBlueprint < ApplicationBlueprint
  identifier :id
  fields :observacao, :laudo_arquivo, :data_laudo, :ativo
  association :g_necessidade_especifica, blueprint: GNecessidadeEspecificaBlueprint
end
