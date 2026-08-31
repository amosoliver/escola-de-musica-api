require "test_helper"

class RFuncionarioFuncaoTest < ActiveSupport::TestCase
  test "nao aceita data_fim menor que data_inicio" do
    vinculo = RFuncionarioFuncao.new(
      r_funcionario: r_funcionarios(:one),
      r_funcao: r_funcoes(:two),
      data_inicio: Date.new(2026, 8, 15),
      data_fim: Date.new(2026, 8, 1)
    )

    assert_not vinculo.valid?
    assert_includes vinculo.errors[:data_fim], "deve ser maior ou igual a data de inicio"
  end
end
