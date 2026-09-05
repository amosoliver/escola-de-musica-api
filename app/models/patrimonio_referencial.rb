# frozen_string_literal: true

class PatrimonioReferencial < ApplicationRecord
  self.abstract_class = true

  acts_as_paranoid

  validates :codigo, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
  validates :descricao, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
end
