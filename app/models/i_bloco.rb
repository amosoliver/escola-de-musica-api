# frozen_string_literal: true

class IBloco < ApplicationRecord
  acts_as_paranoid

  belongs_to :i_predio
  belongs_to :g_andar
  belongs_to :g_unidade_gestora

  has_many :i_ambientes_prediais, dependent: :restrict_with_exception

  before_validation :sincronizar_unidade_gestora

  private

  # g_unidade_gestora_id e' sempre derivado do predio, nunca definido diretamente,
  # pra evitar um bloco divergir do tenant do proprio predio.
  def sincronizar_unidade_gestora
    self.g_unidade_gestora_id = i_predio&.g_unidade_gestora_id
  end
end
