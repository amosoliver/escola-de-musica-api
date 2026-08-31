# frozen_string_literal: true

class RFuncionarioEspecialidade < ApplicationRecord
  acts_as_paranoid

  belongs_to :r_funcionario
  belongs_to :r_especialidade

  validates :r_especialidade_id, uniqueness: {
    scope: :r_funcionario_id,
    conditions: -> { where(deleted_at: nil) }
  }
  validate :data_fim_deve_ser_maior_ou_igual_a_data_inicio

  private

  def data_fim_deve_ser_maior_ou_igual_a_data_inicio
    return if data_inicio.blank? || data_fim.blank?
    return if data_fim >= data_inicio

    errors.add(:data_fim, "deve ser maior ou igual a data de inicio")
  end
end
