# frozen_string_literal: true

class PEmprestimo < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_pessoa
  belongs_to :g_unidade_gestora
  belongs_to :p_status_emprestimo_patrimonio
  belongs_to :r_funcionario_entrega, class_name: "RFuncionario"

  has_many :p_emprestimos_itens, class_name: "PEmprestimoItem", dependent: :restrict_with_exception
  has_many :p_devolucoes, class_name: "PDevolucao", dependent: :restrict_with_exception

  validates :numero_emprestimo, presence: true, uniqueness: {
    scope: :g_unidade_gestora_id,
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
end
