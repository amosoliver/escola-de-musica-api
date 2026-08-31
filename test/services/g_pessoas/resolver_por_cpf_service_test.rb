# frozen_string_literal: true

require "test_helper"

class GPessoas::ResolverPorCpfServiceTest < ActiveSupport::TestCase
  test "reutiliza a pessoa encontrada pelo CPF sem alterar seus dados" do
    pessoa = g_pessoas(:one)

    assert_no_difference("GPessoa.count") do
      result = GPessoas::ResolverPorCpfService.call(
        g_pessoa_id: nil,
        g_pessoa_attributes: { cpf: pessoa.cpf, nome: "Nome nao aplicado" },
        atualizar_g_pessoa: false
      )

      assert result.success?
      assert_equal pessoa, result.value
    end

    assert_equal "MyString", pessoa.reload.nome
  end

  test "atualiza a pessoa encontrada pelo CPF somente com autorizacao explicita" do
    pessoa = g_pessoas(:one)

    result = GPessoas::ResolverPorCpfService.call(
      g_pessoa_id: nil,
      g_pessoa_attributes: { cpf: pessoa.cpf, nome: "Nome atualizado" },
      atualizar_g_pessoa: true
    )

    assert result.success?
    assert_equal "Nome atualizado", pessoa.reload.nome
  end

  test "rejeita CPF divergente quando uma pessoa e informada por ID" do
    result = GPessoas::ResolverPorCpfService.call(
      g_pessoa_id: g_pessoas(:one).id,
      g_pessoa_attributes: { cpf: g_pessoas(:two).cpf },
      atualizar_g_pessoa: true
    )

    assert result.failure?
    assert_includes result.error, "CPF informado nao corresponde"
  end
end
