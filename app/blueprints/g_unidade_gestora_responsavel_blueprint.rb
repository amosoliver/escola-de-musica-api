# frozen_string_literal: true

class GUnidadeGestoraResponsavelBlueprint < ApplicationBlueprint
  identifier :id
  fields :principal, :data_inicio, :data_fim, :ativo
  association :g_pessoa, blueprint: GPessoaBlueprint
  association :r_funcao, blueprint: RFuncaoBlueprint
  association :u_perfil, blueprint: UPerfilBlueprint
end
