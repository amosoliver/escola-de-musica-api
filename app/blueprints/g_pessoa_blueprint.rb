# frozen_string_literal: true

class GPessoaBlueprint < ApplicationBlueprint
  identifier :id
  fields :nome, :nome_social, :cpf, :data_nascimento, :email, :telefone, :whatsapp, :foto, :cep, :logradouro, :numero, :bairro, :cidade, :uf
  association :g_sexo, blueprint: GSexoBlueprint
  association :g_bairro, blueprint: GBairroBlueprint
end
