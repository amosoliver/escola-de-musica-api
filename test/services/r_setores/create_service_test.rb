require "test_helper"

class RSetores::CreateServiceTest < ActiveSupport::TestCase
  test "cria setor com funcoes aninhadas" do
    params = {
      g_unidade_gestora_id: g_unidades_gestoras(:one).id,
      r_setor_pai_id: r_setores(:diretoria_geral).id,
      codigo: "SECRETARIA_ESCOLAR",
      descricao: "Secretaria Escolar",
      ordem: 10,
      ativo: true,
      r_setores_funcoes_attributes: [
        {
          r_funcao_id: r_funcoes(:two).id,
          principal: true,
          ativo: true
        }
      ]
    }

    assert_difference("RSetor.count", 1) do
      assert_difference("RSetorFuncao.count", 1) do
        result = RSetores::CreateService.call(params:)

        assert result.success?
        assert_equal 1, result.value.r_setores_funcoes.size
      end
    end
  end
end
