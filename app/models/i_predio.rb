# frozen_string_literal: true

class IPredio < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora
  belongs_to :g_tipo_predio
  belongs_to :g_situacao_predio
  belongs_to :g_bairro
  belongs_to :g_cidade

  has_many :i_blocos, dependent: :restrict_with_exception
  has_many :g_andares, -> { distinct }, through: :i_blocos

  validate :g_cidade_deve_corresponder_ao_bairro

  def g_pais
    g_cidade&.g_pais
  end

  def g_pais_id
    g_cidade&.g_pais_id
  end

  private

  def g_cidade_deve_corresponder_ao_bairro
    return if g_bairro.blank? || g_cidade.blank?
    return if g_bairro.g_cidade_id == g_cidade_id

    errors.add(:g_cidade, "deve corresponder a cidade do bairro informado")
  end
end
