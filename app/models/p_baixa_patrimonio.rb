# frozen_string_literal: true

class PBaixaPatrimonio < ApplicationRecord
  self.table_name = "p_baixas_patrimonios"

  acts_as_paranoid

  belongs_to :p_patrimonio
  belongs_to :p_tipo_baixa_patrimonio
  belongs_to :g_unidade_gestora
  belongs_to :p_destino_externo, optional: true
  belongs_to :p_movimentacao_patrimonio, optional: true
  belongs_to :r_funcionario, optional: true

  validates :justificativa, presence: true
  validates :p_patrimonio_id, uniqueness: { conditions: -> { where(deleted_at: nil) } }
end
