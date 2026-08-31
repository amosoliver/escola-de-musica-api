# frozen_string_literal: true

class GParentesco < ApplicationRecord
  acts_as_paranoid

  has_many :e_estudantes_responsaveis, dependent: :restrict_with_exception

  validates :descricao, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
end
