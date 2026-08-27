# frozen_string_literal: true

class GUnidadeGestora < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora, class_name: "GUnidadeGestora", optional: true
end
