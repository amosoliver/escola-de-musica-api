# frozen_string_literal: true

class PDestinoExterno < ApplicationRecord
  self.table_name = "p_destinos_externos"

  acts_as_paranoid

  belongs_to :g_unidade_gestora
  belongs_to :g_bairro, optional: true

  has_many :p_movimentacoes_patrimonios, class_name: "PMovimentacaoPatrimonio", dependent: :restrict_with_exception
  has_many :p_manutencoes_patrimonios, class_name: "PManutencaoPatrimonio", dependent: :restrict_with_exception
  has_many :p_baixas_patrimonios, class_name: "PBaixaPatrimonio", dependent: :restrict_with_exception

  validates :nome, presence: true
end
