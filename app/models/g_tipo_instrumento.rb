# frozen_string_literal: true

class GTipoInstrumento < ApplicationRecord
  self.table_name = "g_tipos_instrumentos"

  acts_as_paranoid

  belongs_to :g_classificacao_instrumento

  has_many :g_instrumentos, dependent: :restrict_with_exception

  validates :codigo, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
  validates :descricao, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
end
