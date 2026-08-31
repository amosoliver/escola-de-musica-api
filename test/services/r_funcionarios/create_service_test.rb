require "test_helper"

class RFuncionarios::CreateServiceTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "cria funcionario com pessoa, especialidades e vinculos setor-funcao aninhados" do
    params = {
      g_unidade_gestora_id: g_unidades_gestoras(:one).id,
      r_tipo_vinculo_id: r_tipos_vinculos(:one).id,
      matricula: "FUNC-002",
      data_inicio: Date.new(2026, 2, 1),
      ativo: true,
      g_pessoa_attributes: {
        nome: "Funcionario Novo",
        cpf: "321.654.987-00",
        data_nascimento: Date.new(1990, 2, 10),
        g_sexo_id: g_sexos(:one).id,
        g_bairro_id: g_bairros(:one).id,
        email: "funcionario@example.com"
      },
      r_funcionarios_especialidades_attributes: [
        {
          r_especialidade_id: r_especialidades(:one).id,
          principal: true,
          data_inicio: Date.new(2026, 2, 1),
          ativo: true
        }
      ],
      r_funcionarios_setores_funcoes_attributes: [
        {
          r_setor_funcao_id: r_setores_funcoes(:corpo_docente_professor).id,
          principal: true,
          data_inicio: Date.new(2026, 2, 1),
          ativo: true
        }
      ]
    }

    assert_difference("RFuncionario.count", 1) do
      assert_difference("RFuncionarioEspecialidade.count", 1) do
        assert_difference("RFuncionarioSetorFuncao.count", 1) do
          assert_difference("RFuncionarioFuncao.count", 1) do
            assert_difference("User.count", 1) do
              assert_difference("UserPerfil.count", 1) do
                result = RFuncionarios::CreateService.call(params:)

                assert result.success?
                funcionario = result.value
                assert_equal "Funcionario Novo", funcionario.g_pessoa.nome
                assert_equal g_unidades_gestoras(:one), funcionario.g_unidade_gestora
                assert_equal 1, funcionario.r_funcionarios_especialidades.size
                assert_equal 1, funcionario.r_funcionarios_setores_funcoes.size
                assert_equal [ r_funcoes(:one).id ], funcionario.r_funcionarios_funcoes.pluck(:r_funcao_id)
                assert_equal [ u_perfis(:two).codigo ], funcionario.g_pessoa.user.u_perfis.pluck(:codigo)
                assert_equal 1, ActionMailer::Base.deliveries.size
              end
            end
          end
        end
      end
    end
  end
end
