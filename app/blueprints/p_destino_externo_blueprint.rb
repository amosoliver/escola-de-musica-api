# frozen_string_literal: true

class PDestinoExternoBlueprint < ApplicationBlueprint
  identifier :id
  fields :nome, :razao_social, :cpf_cnpj, :email, :telefone, :cep, :logradouro, :numero, :complemento, :observacao, :ativo
  association :g_bairro, blueprint: GBairroBlueprint
  association :g_unidade_gestora, blueprint: GUnidadeGestoraSummaryBlueprint
end
