# frozen_string_literal: true

class GClassificacaoInstrumento < ApplicationRecord
  self.table_name = "g_classificacoes_instrumentos"

  acts_as_paranoid

  has_many :g_tipos_instrumentos, class_name: "GTipoInstrumento", dependent: :restrict_with_exception

  validates :codigo, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
  validates :descricao, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
end
