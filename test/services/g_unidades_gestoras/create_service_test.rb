require "test_helper"

class GUnidadesGestoras::CreateServiceTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "cria unidade escola com responsavel, usuario e setores padrao" do
    escola_tipo = g_tipos_unidades_gestoras(:two)

    params = {
      g_tipo_unidade_gestora_id: escola_tipo.id,
      nome: "Escola Nova",
      razao_social: "Escola Nova LTDA",
      nome_fantasia: "Escola Nova",
      cnpj: "12345678000199",
      email: "contato@escolanova.com",
      status: "ATIVA",
      g_unidade_gestora_responsavel_attributes: {
        u_perfil_id: u_perfis(:two).id,
        principal: true,
        ativo: true,
        g_pessoa_attributes: {
          nome: "Diretora Nova",
          cpf: "555.444.333-22",
          data_nascimento: Date.new(1980, 1, 1),
          g_sexo_id: g_sexos(:one).id,
          g_bairro_id: g_bairros(:one).id,
          email: "diretora@escolanova.com"
        }
      }
    }

    assert_difference("GUnidadeGestora.count", 1) do
      assert_difference("GUnidadeGestoraResponsavel.count", 1) do
        assert_difference("User.count", 1) do
          assert_difference("UserPerfil.count", 1) do
            result = GUnidadesGestoras::CreateService.call(params:)

            assert result.success?
            unidade = result.value
            assert_equal "Diretora Nova", unidade.reload.responsavel_nome
            assert unidade.g_unidades_gestoras_responsaveis.exists?
            assert unidade.r_setores.exists?
            assert_equal 1, ActionMailer::Base.deliveries.size
          end
        end
      end
    end
  end
end
