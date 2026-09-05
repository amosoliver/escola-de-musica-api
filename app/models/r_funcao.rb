# frozen_string_literal: true

class RFuncao < ApplicationRecord
  acts_as_paranoid

  has_many :r_setores_funcoes, dependent: :destroy
  has_many :r_setores, through: :r_setores_funcoes

  has_many :r_funcoes_perfis, dependent: :destroy
  has_many :u_perfis, through: :r_funcoes_perfis
  has_many :g_unidades_gestoras_responsaveis, dependent: :restrict_with_exception

  accepts_nested_attributes_for :r_funcoes_perfis, allow_destroy: true, reject_if: :all_blank

  validates :descricao, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :codigo, presence: true, uniqueness: {
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validate :apenas_um_perfil_principal_ativo

  def perfis_ativos
    r_funcoes_perfis.includes(:u_perfil).select(&:ativo?).map(&:u_perfil).compact
  end

  private

  def apenas_um_perfil_principal_ativo
    perfis_principais_ativos = r_funcoes_perfis.reject(&:marked_for_destruction?).select do |vinculo|
      vinculo.principal? && vinculo.ativo?
    end

    return unless perfis_principais_ativos.size > 1

    errors.add(:r_funcoes_perfis, "permite apenas um perfil principal ativo")
  end
end
