# frozen_string_literal: true

class GPessoa < ApplicationRecord
  acts_as_paranoid

  before_validation :normalize_cpf

  belongs_to :g_sexo
  belongs_to :g_bairro, optional: true
  has_one :user, dependent: :restrict_with_exception
  has_one :e_estudante, dependent: :restrict_with_exception
  has_one :e_responsavel, dependent: :restrict_with_exception
  has_one :r_funcionario, dependent: :restrict_with_exception
  has_many :g_unidades_gestoras_responsaveis, dependent: :restrict_with_exception

  validates :cpf, uniqueness: { conditions: -> { where(deleted_at: nil) } }, allow_blank: true

  def self.normalize_cpf(value)
    value.to_s.gsub(/\D/, "")
  end

  delegate :g_cidade, to: :g_bairro, allow_nil: true

  def cidade
    g_cidade&.descricao
  end

  def uf
    g_cidade&.uf
  end

  def bairro
    g_bairro&.descricao
  end

  def g_estado
    g_cidade&.g_estado
  end

  def g_pais
    g_cidade&.g_pais
  end

  private

  def normalize_cpf
    self.cpf = self.class.normalize_cpf(cpf).presence
  end
end
