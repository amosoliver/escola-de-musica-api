# frozen_string_literal: true

class PDevolucaoItem < ApplicationRecord
  self.table_name = "p_devolucoes_itens"

  acts_as_paranoid

  belongs_to :p_devolucao
  belongs_to :p_emprestimo_item
  belongs_to :p_estado_conservacao_patrimonio

  validates :p_emprestimo_item_id, uniqueness: { conditions: -> { where(deleted_at: nil) } }
  validates :descricao_avaria, presence: true, if: :possui_avaria?
end
