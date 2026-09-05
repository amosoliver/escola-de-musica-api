# frozen_string_literal: true

class PInventarioItem < ApplicationRecord
  self.table_name = "p_inventarios_itens"

  acts_as_paranoid

  belongs_to :p_inventario
  belongs_to :p_patrimonio
  belongs_to :i_ambiente_predial_encontrado, class_name: "IAmbientePredial", optional: true
  belongs_to :p_estado_conservacao_patrimonio, optional: true

  validates :p_patrimonio_id, uniqueness: {
    scope: :p_inventario_id,
    conditions: -> { where(deleted_at: nil) }
  }
end
