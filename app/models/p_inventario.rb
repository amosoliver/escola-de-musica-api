# frozen_string_literal: true

class PInventario < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora
  belongs_to :i_predio, optional: true
  belongs_to :i_bloco, optional: true
  belongs_to :i_ambiente_predial, optional: true
  belongs_to :r_funcionario_responsavel, class_name: "RFuncionario"

  has_many :p_inventarios_itens, class_name: "PInventarioItem", dependent: :destroy

  validates :descricao, presence: true
end
