# frozen_string_literal: true

class ESaudeEstudanteBlueprint < ApplicationBlueprint
  identifier :id
  fields :observacoes_gerais
  association :e_saudes_estudantes_alergias, blueprint: ESaudeEstudanteAlergiaBlueprint
  association :e_saudes_estudantes_necessidades, blueprint: ESaudeEstudanteNecessidadeBlueprint
end
