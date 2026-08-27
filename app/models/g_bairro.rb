# frozen_string_literal: true
class GBairro < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_cidade
end
