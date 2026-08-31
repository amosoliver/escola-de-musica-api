require "test_helper"

class EEstudantes::CreateServiceTest < ActiveSupport::TestCase
  test "cria estudante com saude, alergias, necessidades e responsavel no mesmo fluxo" do
    params = {
      g_unidade_gestora_id: g_unidades_gestoras(:one).id,
      registro_aluno: "ALU-002",
      emancipado: false,
      proprio_responsavel: false,
      acessa_portal: true,
      g_pessoa_attributes: {
        nome: "Aluno Novo",
        cpf: "111.222.333-44",
        data_nascimento: Date.new(2012, 5, 10),
        g_sexo_id: g_sexos(:one).id,
        g_bairro_id: g_bairros(:one).id,
        email: "aluno.novo@example.com"
      },
      e_saude_estudante_attributes: {
        observacoes_gerais: "Precisa de atencao em atividades intensas",
        e_saudes_estudantes_alergias_attributes: [
          {
            g_alergia_id: g_alergias(:one).id,
            observacao: "Evitar derivados"
          }
        ],
        e_saudes_estudantes_necessidades_attributes: [
          {
            g_necessidade_especifica_id: g_necessidades_especificas(:one).id,
            observacao: "Acompanhamento pedagogico",
            laudo_arquivo: "laudo.pdf",
            data_laudo: Date.new(2026, 7, 1)
          }
        ]
      },
      e_estudantes_responsaveis_attributes: [
        {
          g_parentesco_id: g_parentescos(:one).id,
          responsavel_principal: true,
          responsavel_financeiro: true,
          autorizado_buscar: true,
          data_inicio: Date.new(2026, 1, 1),
          e_responsavel_attributes: {
            ativo: true,
            g_pessoa_attributes: {
              nome: "Responsavel Novo",
              cpf: "555.666.777-88",
              data_nascimento: Date.new(1980, 3, 15),
              g_sexo_id: g_sexos(:two).id,
              g_bairro_id: g_bairros(:two).id,
              email: "responsavel.novo@example.com"
            }
          }
        }
      ]
    }

    assert_difference("EEstudante.count", 1) do
      assert_difference("ESaudeEstudante.count", 1) do
        assert_difference("EEstudanteResponsavel.count", 1) do
          assert_difference("User.count", 2) do
            assert_difference("UserPerfil.count", 2) do
              result = EEstudantes::CreateService.call(params:)

              assert result.success?

              estudante = result.value
              assert_equal "Aluno Novo", estudante.g_pessoa.nome
              assert_equal 1, estudante.e_saude_estudante.e_saudes_estudantes_alergias.size
              assert_equal 1, estudante.e_saude_estudante.e_saudes_estudantes_necessidades.size
              assert_equal 1, estudante.e_estudantes_responsaveis.size
              assert_equal "Responsavel Novo", estudante.e_estudantes_responsaveis.first.e_responsavel.g_pessoa.nome
              assert_equal UPerfil::ALUNO, estudante.g_pessoa.user.u_perfis.first.codigo
              assert_equal UPerfil::RESPONSAVEL_LEGAL, estudante.e_estudantes_responsaveis.first.e_responsavel.g_pessoa.user.u_perfis.first.codigo
              assert_equal 2, ActionMailer::Base.deliveries.size
            end
          end
        end
      end
    end
  end
end
