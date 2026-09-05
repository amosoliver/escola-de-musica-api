# frozen_string_literal: true

class PManutencaoPatrimonio < ApplicationRecord
  self.table_name = "p_manutencoes_patrimonios"

  acts_as_paranoid

  belongs_to :p_patrimonio
  belongs_to :p_tipo_manutencao_patrimonio
  belongs_to :p_status_manutencao_patrimonio
  belongs_to :g_unidade_gestora
  belongs_to :p_destino_externo, optional: true
  belongs_to :r_funcionario_solicitante, class_name: "RFuncionario", optional: true

  validates :descricao_problema, presence: true

  def externa?
    p_destino_externo_id.present?
  end
end
