# frozen_string_literal: true

class PMovimentacaoPatrimonio < ApplicationRecord
  self.table_name = "p_movimentacoes_patrimonios"

  acts_as_paranoid

  belongs_to :p_patrimonio
  belongs_to :p_tipo_movimentacao_patrimonio
  belongs_to :g_unidade_gestora
  belongs_to :i_ambiente_predial_origem, class_name: "IAmbientePredial", optional: true
  belongs_to :i_ambiente_predial_destino, class_name: "IAmbientePredial", optional: true
  belongs_to :p_destino_externo, optional: true
  belongs_to :r_funcionario, optional: true

  has_one :p_baixa_patrimonio, dependent: :restrict_with_exception

  validate :destino_interno_ou_externo_exclusivo

  private

  def destino_interno_ou_externo_exclusivo
    return if i_ambiente_predial_destino_id.present? ^ p_destino_externo_id.present?

    errors.add(:base, "Informe exatamente um destino: ambiente interno ou destino externo")
  end
end
