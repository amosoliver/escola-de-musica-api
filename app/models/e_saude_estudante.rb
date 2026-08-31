# frozen_string_literal: true

class ESaudeEstudante < ApplicationRecord
  acts_as_paranoid

  belongs_to :e_estudante

  has_many :e_saudes_estudantes_alergias, dependent: :destroy
  has_many :g_alergias, through: :e_saudes_estudantes_alergias

  has_many :e_saudes_estudantes_necessidades, dependent: :destroy
  has_many :g_necessidades_especificas, through: :e_saudes_estudantes_necessidades

  accepts_nested_attributes_for :e_saudes_estudantes_alergias, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :e_saudes_estudantes_necessidades, allow_destroy: true, reject_if: :all_blank

  validates :e_estudante_id, uniqueness: { conditions: -> { where(deleted_at: nil) } }
end
