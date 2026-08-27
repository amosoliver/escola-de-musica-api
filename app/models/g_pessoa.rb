# frozen_string_literal: true
class GPessoa < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_sexo
end
