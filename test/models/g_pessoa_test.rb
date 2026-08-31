require "test_helper"

class GPessoaTest < ActiveSupport::TestCase
  test "normaliza CPF antes de validar" do
    pessoa = GPessoa.new(
      nome: "Pessoa CPF",
      cpf: "123.456.789-00",
      g_sexo: g_sexos(:one)
    )

    assert pessoa.valid?
    assert_equal "12345678900", pessoa.cpf
  end

  test "deriva bairro cidade uf e pais a partir do bairro" do
    pessoa = g_pessoas(:one)

    assert_equal g_bairros(:one).descricao, pessoa.bairro
    assert_equal g_cidades(:one).descricao, pessoa.cidade
    assert_equal "RO", pessoa.uf
    assert_equal g_paises(:one), pessoa.g_pais
  end
end
