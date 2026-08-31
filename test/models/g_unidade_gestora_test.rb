require "test_helper"

class GUnidadeGestoraTest < ActiveSupport::TestCase
  test "retorna o codigo do tipo de unidade pela associacao" do
    assert_equal GTipoUnidadeGestora::ADMINISTRACAO, g_unidades_gestoras(:one).tipo_unidade
  end

  test "permite definir o tipo_unidade pelo codigo" do
    unidade = g_unidades_gestoras(:one)

    unidade.tipo_unidade = GTipoUnidadeGestora::ESCOLA

    assert_equal g_tipos_unidades_gestoras(:two), unidade.g_tipo_unidade_gestora
  end

  test "aceita o alias admnistracao" do
    unidade = g_unidades_gestoras(:two)

    unidade.tipo_unidade = GTipoUnidadeGestora::ADMNISTRACAO

    assert_equal g_tipos_unidades_gestoras(:one), unidade.g_tipo_unidade_gestora
  end
end
