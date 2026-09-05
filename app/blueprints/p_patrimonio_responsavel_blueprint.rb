# frozen_string_literal: true

class PPatrimonioResponsavelBlueprint < ApplicationBlueprint
  identifier :id
  fields :data_inicio, :data_fim, :principal, :observacao, :ativo
  association :g_pessoa, blueprint: GPessoaBlueprint
end
