require "test_helper"

class RSetorFuncaoTest < ActiveSupport::TestCase
  test "nao aceita mais de uma funcao principal ativa por setor" do
    vinculo = RSetorFuncao.new(
      r_setor: r_setores(:coordenacao_pedagogica),
      r_funcao: r_funcoes(:one),
      principal: true,
      ativo: true
    )

    assert_not vinculo.valid?
    assert_includes vinculo.errors[:principal], "permite apenas uma funcao principal ativa por setor"
  end
end
