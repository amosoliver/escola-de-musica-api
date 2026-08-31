# frozen_string_literal: true

class RFuncionario < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_pessoa
  belongs_to :g_unidade_gestora
  belongs_to :r_tipo_vinculo

  has_many :r_funcionarios_especialidades, dependent: :destroy
  has_many :r_especialidades, through: :r_funcionarios_especialidades

  has_many :r_funcionarios_funcoes, dependent: :destroy
  has_many :r_funcoes, through: :r_funcionarios_funcoes
  has_many :r_funcionarios_setores_funcoes, dependent: :destroy
  has_many :r_setores_funcoes, through: :r_funcionarios_setores_funcoes
  has_many :r_setores, through: :r_setores_funcoes

  accepts_nested_attributes_for :g_pessoa, update_only: true
  accepts_nested_attributes_for :r_funcionarios_especialidades, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :r_funcionarios_funcoes, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :r_funcionarios_setores_funcoes, allow_destroy: true, reject_if: :all_blank

  validates :matricula, presence: true, uniqueness: {
    scope: :g_unidade_gestora_id,
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }
  validates :g_pessoa_id, uniqueness: { conditions: -> { where(deleted_at: nil) } }
  validate :data_fim_deve_ser_maior_ou_igual_a_data_inicio
  validate :apenas_uma_especialidade_principal_ativa
  validate :apenas_uma_funcao_principal_ativa
  validate :apenas_um_setor_funcao_principal_ativo

  def perfis_de_acesso
    # Prioriza o novo vinculo setor-funcao e mantem fallback para o modelo legado.
    vinculos = r_funcionarios_setores_funcoes.select(&:ativo?)
    vinculos = r_funcionarios_funcoes.select(&:ativo?) if vinculos.empty?

    vinculos
      .flat_map { |vinculo| vinculo.r_funcao&.perfis_ativos || [] }
      .uniq(&:id)
  end

  private

  def apenas_uma_especialidade_principal_ativa
    return unless registros_principais_ativos(r_funcionarios_especialidades).size > 1

    errors.add(:r_funcionarios_especialidades, "permite apenas uma especialidade principal ativa")
  end

  def apenas_uma_funcao_principal_ativa
    return unless registros_principais_ativos(r_funcionarios_funcoes).size > 1

    errors.add(:r_funcionarios_funcoes, "permite apenas uma funcao principal ativa")
  end

  def apenas_um_setor_funcao_principal_ativo
    return unless registros_principais_ativos(r_funcionarios_setores_funcoes).size > 1

    errors.add(:r_funcionarios_setores_funcoes, "permite apenas um vinculo principal ativo")
  end

  def registros_principais_ativos(association)
    association.reject(&:marked_for_destruction?).select do |registro|
      registro.principal? && registro.ativo?
    end
  end

  def data_fim_deve_ser_maior_ou_igual_a_data_inicio
    return if data_inicio.blank? || data_fim.blank?
    return if data_fim >= data_inicio

    errors.add(:data_fim, "deve ser maior ou igual a data de inicio")
  end
end
