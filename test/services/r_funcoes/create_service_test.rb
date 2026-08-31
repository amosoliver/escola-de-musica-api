require "test_helper"

class RFuncoes::CreateServiceTest < ActiveSupport::TestCase
  test "cria funcao com perfis aninhados" do
    params = {
      descricao: "Secretaria Academica",
      codigo: "SECRETARIA_ACADEMICA",
      ativo: true,
      r_funcoes_perfis_attributes: [
        {
          u_perfil_id: u_perfis(:two).id,
          principal: true,
          ativo: true
        },
        {
          u_perfil_id: u_perfis(:responsavel_legal).id,
          principal: false,
          ativo: true
        }
      ]
    }

    assert_difference("RFuncao.count", 1) do
      assert_difference("RFuncaoPerfil.count", 2) do
        result = RFuncoes::CreateService.call(params:)

        assert result.success?
        assert_equal 2, result.value.r_funcoes_perfis.size
      end
    end
  end
end
