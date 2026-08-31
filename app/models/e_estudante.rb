# frozen_string_literal: true

class EEstudante < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_pessoa
  belongs_to :g_unidade_gestora

  has_one :e_saude_estudante, dependent: :destroy
  has_many :e_estudantes_responsaveis, dependent: :destroy
  has_many :e_responsaveis, through: :e_estudantes_responsaveis

  accepts_nested_attributes_for :g_pessoa, update_only: true
  accepts_nested_attributes_for :e_saude_estudante, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :e_estudantes_responsaveis, allow_destroy: true, reject_if: :all_blank

  validates :registro_aluno, presence: true, uniqueness: {
    scope: :g_unidade_gestora_id,
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :g_pessoa_id, uniqueness: { conditions: -> { where(deleted_at: nil) } }
  validates :g_unidade_gestora_id, presence: true
end
