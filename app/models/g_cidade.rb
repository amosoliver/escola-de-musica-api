# frozen_string_literal: true

class GCidade < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_estado
  has_many :g_bairros, dependent: :restrict_with_exception

  delegate :g_pais, :g_pais_id, :uf, to: :g_estado, allow_nil: true
end
