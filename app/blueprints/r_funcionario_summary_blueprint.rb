# frozen_string_literal: true

class RFuncionarioSummaryBlueprint < ApplicationBlueprint
  identifier :id
  fields :matricula
  field :nome do |r_funcionario|
    r_funcionario.g_pessoa&.nome
  end
end
