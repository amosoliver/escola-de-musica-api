# frozen_string_literal: true
class URotaPermissao < ApplicationRecord
  acts_as_paranoid

  belongs_to :u_rota
  belongs_to :u_permissao
end
