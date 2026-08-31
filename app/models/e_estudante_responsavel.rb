# frozen_string_literal: true

class EEstudanteResponsavel < ApplicationRecord
  acts_as_paranoid

  belongs_to :e_estudante
  belongs_to :e_responsavel
  belongs_to :g_parentesco

  accepts_nested_attributes_for :e_responsavel, reject_if: :all_blank

  validates :e_responsavel_id, uniqueness: {
    scope: [ :e_estudante_id, :g_parentesco_id ],
    conditions: -> { where(deleted_at: nil) }
  }
  validate :data_fim_deve_ser_maior_ou_igual_a_data_inicio
  validate :parentesco_outro_deve_ser_coerente
  validate :responsavel_deve_pertencer_a_mesma_unidade

  private

  def data_fim_deve_ser_maior_ou_igual_a_data_inicio
    return if data_inicio.blank? || data_fim.blank?
    return if data_fim >= data_inicio

    errors.add(:data_fim, "deve ser maior ou igual a data de inicio")
  end

  def parentesco_outro_deve_ser_coerente
    return if g_parentesco.blank?

    if g_parentesco.permite_outro?
      errors.add(:parentesco_outro, "deve ser informado") if parentesco_outro.blank?
      return
    end

    errors.add(:parentesco_outro, "deve ficar em branco para o parentesco informado") if parentesco_outro.present?
  end

  def responsavel_deve_pertencer_a_mesma_unidade
    return if e_estudante.blank? || e_responsavel.blank?
    return if e_estudante.g_unidade_gestora_id == e_responsavel.g_unidade_gestora_id

    errors.add(:e_responsavel_id, "deve pertencer a mesma unidade gestora do estudante")
  end
end
