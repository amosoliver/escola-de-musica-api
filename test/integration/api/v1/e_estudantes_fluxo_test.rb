require "test_helper"

class Api::V1::EEstudantesFluxoTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @headers = {
      "Authorization" => "Bearer #{access_token_for(@user)}",
      "Content-Type" => "application/json"
    }
  end

  test "cria estudante com estruturas aninhadas e atualiza saude separadamente" do
    assert_difference("EEstudante.count", 1) do
      assert_difference("User.count", 2) do
        assert_difference("UserPerfil.count", 2) do
      post "/api/v1/e_estudantes",
           params: {
             e_estudante: {
               g_unidade_gestora_id: g_unidades_gestoras(:one).id,
               registro_aluno: "ALU-003",
               acessa_portal: true,
               g_pessoa_attributes: {
                 nome: "Aluno API",
                 cpf: "999.888.777-66",
                  data_nascimento: "2011-09-10",
                  g_sexo_id: g_sexos(:one).id,
                 g_bairro_id: g_bairros(:one).id,
                 email: "aluno.api@example.com"
               },
               e_saude_estudante_attributes: {
                 observacoes_gerais: "Observacao inicial",
                 e_saudes_estudantes_alergias_attributes: [
                   {
                     g_alergia_id: g_alergias(:one).id,
                     observacao: "Monitorar ingestao"
                   }
                 ]
               },
               e_estudantes_responsaveis_attributes: [
                 {
                   g_parentesco_id: g_parentescos(:one).id,
                   responsavel_principal: true,
                   e_responsavel_attributes: {
                     g_pessoa_attributes: {
                       nome: "Mae API",
                       cpf: "123.123.123-12",
                       data_nascimento: "1985-02-20",
                       g_sexo_id: g_sexos(:two).id,
                       g_bairro_id: g_bairros(:two).id,
                       email: "mae.api@example.com"
                     }
                   }
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
    estudante_id = body.dig("data", "id")
    saude_id = body.dig("data", "e_saude_estudante", "id")
    assert_equal "Aluno API", body.dig("data", "g_pessoa", "nome")
    assert_equal 1, body.dig("data", "e_estudantes_responsaveis").size
    assert_equal 2, ActionMailer::Base.deliveries.size

    patch "/api/v1/e_saudes_estudantes/#{saude_id}",
          params: {
            e_saude_estudante: {
              e_estudante_id: estudante_id,
              observacoes_gerais: "Observacao atualizada",
              e_saudes_estudantes_necessidades_attributes: [
                {
                  g_necessidade_especifica_id: g_necessidades_especificas(:one).id,
                  observacao: "Apoio educacional",
                  laudo_arquivo: "apoio.pdf",
                  data_laudo: "2026-08-01"
                }
              ]
            }
          }.to_json,
          headers: @headers

    assert_response :success
    body = parse_response_body
    assert_equal "Observacao atualizada", body.dig("data", "observacoes_gerais")
    assert_equal 1, body.dig("data", "e_saudes_estudantes_necessidades").size
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
