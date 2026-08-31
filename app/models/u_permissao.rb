# frozen_string_literal: true
class UPermissao < ApplicationRecord
  acts_as_paranoid

  has_many :u_perfis_permissoes, dependent: :destroy
  has_many :u_perfis, through: :u_perfis_permissoes

  has_many :u_rotas_permissoes, dependent: :destroy
  has_many :u_rotas, through: :u_rotas_permissoes
end
