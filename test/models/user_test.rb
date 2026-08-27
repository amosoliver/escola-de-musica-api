# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes cpf and email before validation" do
    user = User.new(cpf: "123.456.789-01", email: "  TESTE@EXAMPLE.COM  ", password: "102030")

    user.valid?

    assert_equal "12345678901", user.cpf
    assert_equal "teste@example.com", user.email
  end

  test "finds authentication by cpf or email" do
    by_cpf = User.create!(cpf: "12345678901", email: "cpf@example.com", password: "102030")
    by_email = User.create!(cpf: "12345678902", email: "email@example.com", password: "102030")

    assert_equal by_cpf, User.find_for_database_authentication(login: "123.456.789-01")
    assert_equal by_email, User.find_for_database_authentication(login: "EMAIL@example.com")
  end

  test "allows user without email" do
    user = User.create!(cpf: "12345678903", password: "102030")

    assert_nil user.email
    assert user.valid?
  end
end
