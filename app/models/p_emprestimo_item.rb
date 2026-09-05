# frozen_string_literal: true

class PEmprestimoItem < ApplicationRecord
  self.table_name = "p_emprestimos_itens"

  acts_as_paranoid

  belongs_to :p_emprestimo
  belongs_to :p_patrimonio
  belongs_to :p_estado_conservacao_patrimonio

  has_one :p_devolucao_item, dependent: :restrict_with_exception

  validates :p_patrimonio_id, uniqueness: {
    scope: :p_emprestimo_id,
    conditions: -> { where(deleted_at: nil) }
  }

  def devolvido?
    p_devolucao_item.present?
  end
end
