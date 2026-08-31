# frozen_string_literal: true
class USidebar < ApplicationRecord
  acts_as_paranoid

  belongs_to :u_template
  has_many :u_sidebar_itens, dependent: :restrict_with_exception
end
