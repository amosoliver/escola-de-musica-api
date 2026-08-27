# frozen_string_literal: true

class IPredio < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora
  belongs_to :g_tipo_predio
  belongs_to :g_situacao_predio
  belongs_to :g_bairro
  belongs_to :g_cidade
  belongs_to :g_pais
end
