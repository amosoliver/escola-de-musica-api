# frozen_string_literal: true

class GEstado < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_pais
  has_many :g_cidades, dependent: :nullify
end
