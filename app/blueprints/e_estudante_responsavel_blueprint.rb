# frozen_string_literal: true

class EEstudanteResponsavelBlueprint < ApplicationBlueprint
  identifier :id
  fields :parentesco_outro,
         :responsavel_principal,
         :responsavel_financeiro,
         :autorizado_buscar,
         :data_inicio,
         :data_fim,
         :ativo

  association :g_parentesco, blueprint: GParentescoBlueprint
  association :e_responsavel, blueprint: EResponsavelBlueprint
end
