# frozen_string_literal: true

class ESaudeEstudanteAlergia < ApplicationRecord
  self.table_name = "e_saudes_estudantes_alergias"

  acts_as_paranoid

  belongs_to :e_saude_estudante
  belongs_to :g_alergia

  validates :g_alergia_id, uniqueness: {
    scope: :e_saude_estudante_id,
    conditions: -> { where(deleted_at: nil) }
  }
end
