# frozen_string_literal: true

class EEstudanteBlueprint < ApplicationBlueprint
  identifier :id
  fields :registro_aluno, :emancipado, :proprio_responsavel, :acessa_portal
  association :g_unidade_gestora, blueprint: GUnidadeGestoraSummaryBlueprint
  association :g_pessoa, blueprint: GPessoaBlueprint
  association :e_saude_estudante, blueprint: ESaudeEstudanteBlueprint
  association :e_estudantes_responsaveis, blueprint: EEstudanteResponsavelBlueprint
end
