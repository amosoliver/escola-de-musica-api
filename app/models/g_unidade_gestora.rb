# frozen_string_literal: true

class GUnidadeGestora < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora, class_name: "GUnidadeGestora", optional: true
  belongs_to :g_tipo_unidade_gestora
  has_many :g_unidades_gestoras_responsaveis, dependent: :destroy
  has_many :r_funcionarios, dependent: :restrict_with_exception
  has_many :r_setores, dependent: :restrict_with_exception

  validates :g_tipo_unidade_gestora, presence: true

  def responsavel_principal
    g_unidades_gestoras_responsaveis.includes(:g_pessoa, :u_perfil, :r_funcao).find_by(principal: true, ativo: true)
  end

  def tipo_unidade
    g_tipo_unidade_gestora&.codigo
  end

  def tipo_unidade=(value)
    self.g_tipo_unidade_gestora = find_tipo_unidade(value)
  end

  private

  def find_tipo_unidade(value)
    normalized_value = value.to_s.strip.upcase
    return if normalized_value.blank?

    normalized_value = GTipoUnidadeGestora::ADMINISTRACAO if normalized_value == GTipoUnidadeGestora::ADMNISTRACAO

    GTipoUnidadeGestora.find_by(codigo: normalized_value) ||
      GTipoUnidadeGestora.find_by(descricao: value.to_s.strip)
  end
end
