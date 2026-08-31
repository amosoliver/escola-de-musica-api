# frozen_string_literal: true

class IAmbientePredial < ApplicationRecord
  acts_as_paranoid

  belongs_to :i_bloco
  belongs_to :g_tipo_ambiente_predial
  belongs_to :g_unidade_gestora

  delegate :i_predio, :g_andar, to: :i_bloco

  before_validation :sincronizar_unidade_gestora

  private

  # g_unidade_gestora_id e' sempre derivado do bloco, nunca definido diretamente,
  # pra evitar um ambiente divergir do tenant do proprio bloco/predio.
  def sincronizar_unidade_gestora
    self.g_unidade_gestora_id = i_bloco&.g_unidade_gestora_id
  end
end
