# frozen_string_literal: true
class UPerfilTemplate < ApplicationRecord
  acts_as_paranoid

  belongs_to :u_perfil
  belongs_to :u_template
end
