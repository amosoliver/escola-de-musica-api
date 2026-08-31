require "test_helper"

class GUnidadeGestoraResponsavelTest < ActiveSupport::TestCase
  test "exige perfil ou funcao para o responsavel" do
    responsavel = GUnidadeGestoraResponsavel.new(
      g_unidade_gestora: g_unidades_gestoras(:one),
      g_pessoa: g_pessoas(:one),
      principal: true,
      ativo: true
    )

    assert_not responsavel.valid?
    assert_includes responsavel.errors[:base], "informe um perfil ou uma funcao para o responsavel"
  end
end
