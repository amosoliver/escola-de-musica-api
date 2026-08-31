# frozen_string_literal: true

class GAndar < ApplicationRecord
  acts_as_paranoid

  has_many :i_blocos, dependent: :restrict_with_exception
  has_many :i_predios, -> { distinct }, through: :i_blocos
end
