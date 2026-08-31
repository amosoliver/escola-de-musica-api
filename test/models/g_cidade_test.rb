require "test_helper"

class GCidadeTest < ActiveSupport::TestCase
  test "deriva uf e pais a partir do estado" do
    cidade = g_cidades(:one)

    assert_equal "RO", cidade.uf
    assert_equal g_paises(:one), cidade.g_pais
  end
end
