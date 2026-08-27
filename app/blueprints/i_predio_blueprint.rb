# frozen_string_literal: true

class IPredioBlueprint < ApplicationBlueprint
  identifier :id
  fields :nome, :latitude, :longitude, :cep, :logradouro, :numero, :complemento, :telefone_contato, :email_responsavel, :data_inicio, :data_fim, :principal, :ativo
  association :g_unidade_gestora, blueprint: GUnidadeGestoraBlueprint
  association :g_tipo_predio, blueprint: GTipoPredioBlueprint
  association :g_situacao_predio, blueprint: GSituacaoPredioBlueprint
  association :g_bairro, blueprint: GBairroBlueprint
  association :g_cidade, blueprint: GCidadeBlueprint
  association :g_pais, blueprint: GPaisBlueprint
end
