# frozen_string_literal: true

class USidebarItem < ApplicationRecord
  acts_as_paranoid

  belongs_to :u_sidebar
  belongs_to :u_sidebar_item_pai, class_name: "USidebarItem", optional: true
  belongs_to :u_rota
end
