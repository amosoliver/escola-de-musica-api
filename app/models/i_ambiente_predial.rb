# frozen_string_literal: true

class IAmbientePredial < ApplicationRecord
  acts_as_paranoid

  belongs_to :i_bloco
  belongs_to :g_tipo_ambiente_predial
end
