require "test_helper"

class Api::V1::RFuncionariosFluxoTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @headers = {
      "Authorization" => "Bearer #{access_token_for(@user)}",
      "Content-Type" => "application/json"
    }
    ActionMailer::Base.deliveries.clear
  end

  test "cria funcionario com aninhamentos e atualiza vinculo setor-funcao" do
    assert_difference("RFuncionario.count", 1) do
      assert_difference("User.count", 1) do
        assert_difference("UserPerfil.count", 1) do
          post "/api/v1/r_funcionarios",
               params: {
                 r_funcionario: {
                   g_unidade_gestora_id: g_unidades_gestoras(:one).id,
                   r_tipo_vinculo_id: r_tipos_vinculos(:one).id,
                   matricula: "FUNC-003",
                   data_inicio: "2026-03-01",
                   ativo: true,
                   g_pessoa_attributes: {
                     nome: "Funcionario API",
                     cpf: "654.321.987-00",
                     data_nascimento: "1988-11-20",
                     g_sexo_id: g_sexos(:one).id,
                     g_bairro_id: g_bairros(:one).id,
                     email: "funcionario.api@example.com"
                   },
                   r_funcionarios_especialidades_attributes: [
                     {
                       r_especialidade_id: r_especialidades(:one).id,
                       principal: true,
                       data_inicio: "2026-03-01",
                       ativo: true
                     }
                   ],
                   r_funcionarios_setores_funcoes_attributes: [
                     {
                       r_setor_funcao_id: r_setores_funcoes(:corpo_docente_professor).id,
                       principal: true,
                       data_inicio: "2026-03-01",
                       ativo: true
                     }
                   ]
                 }
               }.to_json,
               headers: @headers
        end
      end
    end

    assert_response :created
    body = parse_response_body
    funcionario_id = body.dig("data", "id")
    funcao_vinculo_id = body.dig("data", "r_funcionarios_setores_funcoes", 0, "id")
    assert_equal "Funcionario API", body.dig("data", "g_pessoa", "nome")
    assert_equal 1, body.dig("data", "r_funcionarios_especialidades").size
    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_difference("UserPerfil.count", 1) do
      patch "/api/v1/r_funcionarios/#{funcionario_id}",
            params: {
              r_funcionario: {
                g_unidade_gestora_id: g_unidades_gestoras(:one).id,
                r_tipo_vinculo_id: r_tipos_vinculos(:two).id,
                r_funcionarios_setores_funcoes_attributes: [
                  {
                    id: funcao_vinculo_id,
                    r_setor_funcao_id: r_setores_funcoes(:corpo_docente_professor).id,
                    principal: false,
                    data_inicio: "2026-03-01",
                    ativo: true
                  },
                  {
                    r_setor_funcao_id: r_setores_funcoes(:coord_pedagogica_coordenador).id,
                    principal: true,
                    data_inicio: "2026-04-01",
                    ativo: true
                  }
                ]
              }
            }.to_json,
            headers: @headers
    end

    assert_response :success
    body = parse_response_body
    assert_equal r_tipos_vinculos(:two).id, body.dig("data", "r_tipo_vinculo", "id")
    assert_equal 2, body.dig("data", "r_funcionarios_setores_funcoes").size
    assert_equal [ u_perfis(:one).codigo, u_perfis(:two).codigo ].sort,
                 RFuncionario.find(funcionario_id).g_pessoa.user.u_perfis.order(:codigo).pluck(:codigo).sort
  end

  private

  def access_token_for(user)
    Auth::JsonWebToken.encode(
      sub: user.id,
      typ: "access",
      exp: 1.day.from_now.to_i
    )
  end
end
