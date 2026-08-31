# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_pessoa, optional: true
  has_many :users_perfis, dependent: :restrict_with_exception
  has_many :u_perfis, through: :users_perfis

  attr_writer :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :normalize_login_fields

  validates :cpf, presence: true, uniqueness: true, length: { is: 11 }
  validates :email, uniqueness: true, allow_blank: true
  validates :g_pessoa_id, uniqueness: true, allow_nil: true

  def login
    @login || cpf || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)&.to_s
    query = where(conditions)

    return query.first if login.blank?

    normalized_login = normalize_cpf(login)
    query.find_by("lower(email) = :email OR cpf = :cpf", email: login.downcase, cpf: normalized_login)
  end

  def self.send_reset_password_instructions(attributes = {})
    recoverable = find_recoverable_for_password_reset(attributes)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  private

  def self.find_recoverable_for_password_reset(attributes)
    login = attributes[:login].to_s.strip
    return new.tap { |record| record.errors.add(:login, :blank) } if login.blank?

    recoverable = find_for_database_authentication(login:)
    return recoverable if recoverable.present?

    new.tap { |record| record.errors.add(:login, :not_found) }
  end

  def normalize_login_fields
    self.email = email.to_s.strip.downcase.presence
    self.cpf = self.class.normalize_cpf(cpf)
  end

  def self.normalize_cpf(value)
    value.to_s.gsub(/\D/, "")
  end
end
