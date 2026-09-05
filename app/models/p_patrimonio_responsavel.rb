# frozen_string_literal: true

class PPatrimonioResponsavel < ApplicationRecord
  self.table_name = "p_patrimonios_responsaveis"

  acts_as_paranoid

  belongs_to :p_patrimonio
  belongs_to :g_pessoa

  validates :g_pessoa_id, uniqueness: {
    scope: :p_patrimonio_id,
    conditions: -> { where(deleted_at: nil) }
  }
  validate :apenas_um_principal_ativo_por_patrimonio
  validate :data_fim_deve_ser_maior_ou_igual_a_data_inicio

  private

  def apenas_um_principal_ativo_por_patrimonio
    return unless principal? && ativo?

    outros = PPatrimonioResponsavel.where(p_patrimonio_id: p_patrimonio_id, principal: true, ativo: true)
    outros = outros.where.not(id: id) if persisted?
    return unless outros.exists?

    errors.add(:principal, "ja existe um responsavel principal ativo para este patrimonio")
  end

  def data_fim_deve_ser_maior_ou_igual_a_data_inicio
    return if data_inicio.blank? || data_fim.blank?
    return if data_fim >= data_inicio

    errors.add(:data_fim, "deve ser maior ou igual a data de inicio")
  end
end
