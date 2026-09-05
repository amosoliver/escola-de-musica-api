# frozen_string_literal: true

class GTipoPatrimonio < ApplicationRecord
  self.table_name = "g_tipos_patrimonios"

  acts_as_paranoid

  belongs_to :g_categoria_patrimonio

  has_many :p_patrimonios, dependent: :restrict_with_exception

  validates :codigo, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
  validates :descricao, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
end
