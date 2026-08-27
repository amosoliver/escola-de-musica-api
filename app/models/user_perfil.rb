# frozen_string_literal: true
class UserPerfil < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :u_perfil
  belongs_to :g_unidade_gestora
end
