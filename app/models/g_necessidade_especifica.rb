# frozen_string_literal: true

class GNecessidadeEspecifica < ApplicationRecord
  acts_as_paranoid

  has_many :e_saudes_estudantes_necessidades, dependent: :restrict_with_exception

  validates :descricao, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
end
