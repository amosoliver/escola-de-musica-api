# frozen_string_literal: true
class UTemplate < ApplicationRecord
  acts_as_paranoid

  has_many :u_perfis_templates, dependent: :destroy
  has_many :u_perfis, through: :u_perfis_templates

  has_many :u_sidebars, dependent: :restrict_with_exception
end
