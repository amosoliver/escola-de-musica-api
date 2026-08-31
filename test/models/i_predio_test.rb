require "test_helper"

class IPredioTest < ActiveSupport::TestCase
  test "deriva o pais a partir da cidade" do
    predio = i_predios(:one)

    assert_equal g_paises(:one), predio.g_pais
  end

  test "valida consistencia entre bairro e cidade" do
    predio = i_predios(:one)
    predio.g_cidade = g_cidades(:two)

    assert_not predio.valid?
    assert_includes predio.errors[:g_cidade], "deve corresponder a cidade do bairro informado"
  end
end
