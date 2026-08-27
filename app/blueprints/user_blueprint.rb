# frozen_string_literal: true

class UserBlueprint < ApplicationBlueprint
  identifier :id
  fields :cpf, :email, :bloqueado, :primeiro_acesso, :data_ultimo_acesso
  association :g_pessoa, blueprint: GPessoaBlueprint
end
