# frozen_string_literal: true
class GPais < ApplicationRecord
  acts_as_paranoid
  has_many :g_estados, dependent: :restrict_with_exception
  has_many :g_cidades, dependent: :restrict_with_exception
end
