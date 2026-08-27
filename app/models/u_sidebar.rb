# frozen_string_literal: true
class USidebar < ApplicationRecord
  acts_as_paranoid

  belongs_to :u_template
end
