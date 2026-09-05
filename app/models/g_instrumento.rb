# frozen_string_literal: true

class GInstrumento < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_tipo_instrumento

  has_many :p_patrimonios, dependent: :restrict_with_exception

  delegate :g_classificacao_instrumento, to: :g_tipo_instrumento, allow_nil: true

  validates :codigo, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
  validates :descricao, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }
end
