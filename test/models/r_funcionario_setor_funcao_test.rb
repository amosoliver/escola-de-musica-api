require "test_helper"

class RFuncionarioSetorFuncaoTest < ActiveSupport::TestCase
  test "nao aceita data_fim menor que data_inicio" do
    vinculo = RFuncionarioSetorFuncao.new(
      r_funcionario: r_funcionarios(:one),
      r_setor_funcao: r_setores_funcoes(:tesouraria_coordenador),
      data_inicio: Date.new(2026, 8, 15),
      data_fim: Date.new(2026, 8, 1)
    )

    assert_not vinculo.valid?
    assert_includes vinculo.errors[:data_fim], "deve ser maior ou igual a data de inicio"
  end
end
