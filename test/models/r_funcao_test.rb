require "test_helper"

class RFuncaoTest < ActiveSupport::TestCase
  test "nao aceita mais de um perfil principal ativo" do
    funcao = r_funcoes(:one)
    funcao.r_funcoes_perfis.build(
      u_perfil: u_perfis(:one),
      principal: true,
      ativo: true
    )

    assert_not funcao.valid?
    assert_includes funcao.errors[:r_funcoes_perfis], "permite apenas um perfil principal ativo"
  end
end
