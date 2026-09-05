require "test_helper"

class RFuncionarioTest < ActiveSupport::TestCase
  test "valida periodo do funcionario" do
    funcionario = RFuncionario.new(
      g_pessoa: g_pessoas(:two),
      g_unidade_gestora: g_unidades_gestoras(:one),
      r_tipo_vinculo: r_tipos_vinculos(:one),
      matricula: "FUNC-999",
      data_inicio: Date.new(2026, 8, 20),
      data_fim: Date.new(2026, 8, 10)
    )

    assert_not funcionario.valid?
    assert_includes funcionario.errors[:data_fim], "deve ser maior ou igual a data de inicio"
  end

  test "nao aceita mais de uma especialidade principal ativa" do
    funcionario = r_funcionarios(:one)
    funcionario.r_funcionarios_especialidades.build(
      r_especialidade: r_especialidades(:two),
      principal: true,
      data_inicio: Date.new(2026, 2, 1),
      ativo: true
    )

    assert_not funcionario.valid?
    assert_includes funcionario.errors[:r_funcionarios_especialidades], "permite apenas uma especialidade principal ativa"
  end

  test "nao aceita mais de um vinculo principal ativo de setor-funcao" do
    funcionario = r_funcionarios(:one)
    funcionario.r_funcionarios_setores_funcoes.build(
      r_setor_funcao: r_setores_funcoes(:coord_pedagogica_coordenador),
      principal: true,
      data_inicio: Date.new(2026, 2, 1),
      ativo: true
    )

    assert_not funcionario.valid?
    assert_includes funcionario.errors[:r_funcionarios_setores_funcoes], "permite apenas um vinculo principal ativo"
  end
end
