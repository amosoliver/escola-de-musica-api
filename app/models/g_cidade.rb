# frozen_string_literal: true
class GCidade < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_pais
  belongs_to :g_estado, optional: true
  has_many :g_bairros, dependent: :restrict_with_exception
end
