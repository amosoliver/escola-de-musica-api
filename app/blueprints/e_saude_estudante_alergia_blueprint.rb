# frozen_string_literal: true

class ESaudeEstudanteAlergiaBlueprint < ApplicationBlueprint
  identifier :id
  fields :observacao, :ativo
  association :g_alergia, blueprint: GAlergiaBlueprint
end
