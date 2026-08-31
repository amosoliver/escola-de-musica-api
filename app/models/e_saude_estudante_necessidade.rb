# frozen_string_literal: true

class ESaudeEstudanteNecessidade < ApplicationRecord
  self.table_name = "e_saudes_estudantes_necessidades"

  acts_as_paranoid

  belongs_to :e_saude_estudante
  belongs_to :g_necessidade_especifica

  validates :g_necessidade_especifica_id, uniqueness: {
    scope: :e_saude_estudante_id,
    conditions: -> { where(deleted_at: nil) }
  }
  validate :data_laudo_nao_pode_ser_futura

  private

  def data_laudo_nao_pode_ser_futura
    return if data_laudo.blank? || data_laudo <= Date.current

    errors.add(:data_laudo, "nao pode ser futura")
  end
end
