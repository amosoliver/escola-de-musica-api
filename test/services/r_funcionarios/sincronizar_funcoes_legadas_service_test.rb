require "test_helper"

class RFuncionarios::SincronizarFuncoesLegadasServiceTest < ActiveSupport::TestCase
  test "sincroniza r_funcionarios_funcoes a partir dos vinculos de setor-funcao" do
    funcionario = r_funcionarios(:one)
    funcionario.r_funcionarios_funcoes.destroy_all

    result = RFuncionarios::SincronizarFuncoesLegadasService.call(r_funcionario: funcionario)

    assert result.success?
    assert_equal [ r_funcoes(:one).id ], funcionario.reload.r_funcionarios_funcoes.pluck(:r_funcao_id)
    assert_predicate funcionario.r_funcionarios_funcoes.first, :principal?
  end

  test "remove funcao legada que nao existe mais no vinculo de setor-funcao" do
    funcionario = r_funcionarios(:one)
    funcionario.r_funcionarios_setores_funcoes.first.update!(ativo: false)

    result = RFuncionarios::SincronizarFuncoesLegadasService.call(r_funcionario: funcionario)

    assert result.success?
    assert_equal 0, funcionario.reload.r_funcionarios_funcoes.count
  end
end
