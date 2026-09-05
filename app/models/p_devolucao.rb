# frozen_string_literal: true

class PDevolucao < ApplicationRecord
  self.table_name = "p_devolucoes"

  acts_as_paranoid

  belongs_to :p_emprestimo
  belongs_to :g_unidade_gestora
  belongs_to :r_funcionario_recebimento, class_name: "RFuncionario"

  has_many :p_devolucoes_itens, class_name: "PDevolucaoItem", dependent: :restrict_with_exception
end
