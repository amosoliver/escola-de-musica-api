# frozen_string_literal: true

class IBloco < ApplicationRecord
  acts_as_paranoid

  belongs_to :i_predio
  belongs_to :g_andar
end
