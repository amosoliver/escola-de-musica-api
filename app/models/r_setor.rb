# frozen_string_literal: true

class RSetor < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora
  belongs_to :r_setor_pai, class_name: "RSetor", optional: true

  has_many :r_setores_filhos,
           class_name: "RSetor",
           foreign_key: :r_setor_pai_id,
           dependent: :restrict_with_exception,
           inverse_of: :r_setor_pai
  has_many :r_setores_funcoes, dependent: :destroy
  has_many :r_funcoes, through: :r_setores_funcoes

  accepts_nested_attributes_for :r_setores_funcoes, allow_destroy: true, reject_if: :all_blank

  validates :descricao, presence: true, uniqueness: {
    scope: :g_unidade_gestora_id,
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :codigo, presence: true, uniqueness: {
    scope: :g_unidade_gestora_id,
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :ordem, numericality: { only_integer: true }, allow_nil: true
  validate :r_setor_pai_da_mesma_unidade
  validate :nao_pode_ser_pai_de_si_mesmo

  private

  def r_setor_pai_da_mesma_unidade
    return if r_setor_pai.blank? || r_setor_pai.g_unidade_gestora_id == g_unidade_gestora_id

    errors.add(:r_setor_pai_id, "deve pertencer a mesma unidade gestora")
  end

  def nao_pode_ser_pai_de_si_mesmo
    return if id.blank? || r_setor_pai_id != id

    errors.add(:r_setor_pai_id, "nao pode referenciar o proprio setor")
  end
end
