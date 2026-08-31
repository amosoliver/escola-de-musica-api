# frozen_string_literal: true

class GTipoUnidadeGestora < ApplicationRecord
  acts_as_paranoid

  ADMINISTRACAO = "ADMINISTRACAO".freeze
  ADMNISTRACAO = ADMINISTRACAO
  ESCOLA = "ESCOLA".freeze

  has_many :g_unidades_gestoras, dependent: :restrict_with_exception

  validates :codigo, presence: true, uniqueness: true
  validates :descricao, presence: true, uniqueness: true
end
