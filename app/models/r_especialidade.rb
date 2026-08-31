# frozen_string_literal: true

class REspecialidade < ApplicationRecord
  acts_as_paranoid

  has_many :r_funcionarios_especialidades, dependent: :restrict_with_exception
  has_many :r_funcionarios, through: :r_funcionarios_especialidades

  validates :descricao, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :codigo, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
end
