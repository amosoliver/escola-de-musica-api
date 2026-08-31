# frozen_string_literal: true

class GUnidadeGestoraResponsavel < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora
  belongs_to :g_pessoa
  belongs_to :r_funcao, optional: true
  belongs_to :u_perfil, optional: true

  validates :g_pessoa_id, uniqueness: {
    scope: :g_unidade_gestora_id,
    conditions: -> { where(deleted_at: nil) }
  }
  validate :data_fim_deve_ser_maior_ou_igual_a_data_inicio
  validate :perfil_ou_funcao_deve_ser_informado
  validate :apenas_um_responsavel_principal_ativo

  def perfil_de_acesso
    u_perfil || r_funcao&.perfis_ativos&.find { |perfil| perfil.present? }
  end

  private

  def data_fim_deve_ser_maior_ou_igual_a_data_inicio
    return if data_inicio.blank? || data_fim.blank?
    return if data_fim >= data_inicio

    errors.add(:data_fim, "deve ser maior ou igual a data de inicio")
  end

  def perfil_ou_funcao_deve_ser_informado
    return if u_perfil.present? || r_funcao.present?

    errors.add(:base, "informe um perfil ou uma funcao para o responsavel")
  end

  def apenas_um_responsavel_principal_ativo
    return unless principal? && ativo?

    scope = self.class.where(g_unidade_gestora_id:, principal: true, ativo: true, deleted_at: nil)
    scope = scope.where.not(id:) if persisted?
    return unless scope.exists?

    errors.add(:principal, "permite apenas um responsavel principal ativo por unidade gestora")
  end
end
