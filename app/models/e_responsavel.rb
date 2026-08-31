# frozen_string_literal: true

class EResponsavel < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_pessoa
  belongs_to :g_unidade_gestora

  has_many :e_estudantes_responsaveis, dependent: :destroy
  has_many :e_estudantes, through: :e_estudantes_responsaveis

  accepts_nested_attributes_for :g_pessoa, update_only: true

  validates :g_pessoa_id, uniqueness: {
    scope: :g_unidade_gestora_id,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :g_unidade_gestora_id, presence: true
end
