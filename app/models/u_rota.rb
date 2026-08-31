# frozen_string_literal: true
class URota < ApplicationRecord
  acts_as_paranoid

  has_many :u_rotas_permissoes, dependent: :destroy
  has_many :u_permissoes, through: :u_rotas_permissoes
end
