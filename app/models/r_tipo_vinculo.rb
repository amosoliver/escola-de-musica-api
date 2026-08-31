# frozen_string_literal: true

class RTipoVinculo < ApplicationRecord
  acts_as_paranoid

  has_many :r_funcionarios, dependent: :restrict_with_exception

  validates :descricao, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :codigo, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
end
