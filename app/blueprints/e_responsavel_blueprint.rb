# frozen_string_literal: true

class EResponsavelBlueprint < ApplicationBlueprint
  identifier :id
  fields :ativo
  association :g_unidade_gestora, blueprint: GUnidadeGestoraSummaryBlueprint
  association :g_pessoa, blueprint: GPessoaBlueprint
end
