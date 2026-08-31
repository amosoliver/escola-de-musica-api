# frozen_string_literal: true

class RFuncaoPerfil < ApplicationRecord
  acts_as_paranoid

  belongs_to :r_funcao
  belongs_to :u_perfil

  validates :u_perfil_id, uniqueness: {
    scope: :r_funcao_id,
    conditions: -> { where(deleted_at: nil) }
  }
end
