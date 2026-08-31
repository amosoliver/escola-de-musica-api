# frozen_string_literal: true

class RFuncionarioSetorFuncao < ApplicationRecord
  acts_as_paranoid

  belongs_to :r_funcionario
  belongs_to :r_setor_funcao

  delegate :r_setor, :r_funcao, to: :r_setor_funcao

  validates :r_setor_funcao_id, uniqueness: {
    scope: :r_funcionario_id,
    conditions: -> { where(deleted_at: nil) }
  }
  validate :data_fim_deve_ser_maior_ou_igual_a_data_inicio
  validate :setor_funcao_deve_pertencer_a_mesma_unidade_do_funcionario

  private

  def data_fim_deve_ser_maior_ou_igual_a_data_inicio
    return if data_inicio.blank? || data_fim.blank?
    return if data_fim >= data_inicio

    errors.add(:data_fim, "deve ser maior ou igual a data de inicio")
  end

  def setor_funcao_deve_pertencer_a_mesma_unidade_do_funcionario
    return if r_funcionario.blank? || r_setor.blank?
    return if r_funcionario.g_unidade_gestora_id == r_setor.g_unidade_gestora_id

    errors.add(:r_setor_funcao_id, "deve pertencer a mesma unidade gestora do funcionario")
  end
end
