# frozen_string_literal: true

class GCategoriaPatrimonio < ApplicationRecord
  self.table_name = "g_categorias_patrimonios"

  acts_as_paranoid

  has_many :g_tipos_patrimonios, class_name: "GTipoPatrimonio", dependent: :restrict_with_exception

  validates :codigo, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
  validates :descricao, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
end
