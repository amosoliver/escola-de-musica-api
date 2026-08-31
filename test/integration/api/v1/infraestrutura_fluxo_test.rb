require "test_helper"

class Api::V1::InfraestruturaFluxoTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @headers = {
      "Authorization" => "Bearer #{access_token_for(@user)}",
      "Content-Type" => "application/json"
    }
  end

  test "lista andares por predio" do
    predio = i_predios(:one)
    andar_extra = GAndar.create!(descricao: "Segundo Andar", ordem: 2)
    IBloco.create!(i_predio: predio, g_andar: andar_extra, descricao: "Bloco B", ativo: true)

    get "/api/v1/i_predios/#{predio.id}/g_andares", headers: @headers

    assert_response :success
    body = parse_response_body
    assert_equal true, body["success"]
    assert_equal [ g_andares(:one).id, andar_extra.id ].sort, body.dig("data", "items").map { |item| item["id"] }.sort
  end

  test "lista e cria blocos por predio e andar" do
    predio = i_predios(:one)
    andar = g_andares(:one)

    get "/api/v1/i_predios/#{predio.id}/g_andares/#{andar.id}/i_blocos", headers: @headers

    assert_response :success
    body = parse_response_body
    assert_equal [ i_blocos(:one).id ], body.dig("data", "items").map { |item| item["id"] }

    assert_difference("IBloco.count", 1) do
      post "/api/v1/i_predios/#{predio.id}/g_andares/#{andar.id}/i_blocos",
           params: {
             i_bloco: {
               descricao: "Bloco Novo",
               ativo: true
             }
           }.to_json,
           headers: @headers
    end

    assert_response :created
    bloco = IBloco.order(:id).last
    assert_equal predio, bloco.i_predio
    assert_equal andar, bloco.g_andar
    assert_equal predio.g_unidade_gestora, bloco.g_unidade_gestora
  end

  test "atualiza e remove bloco pelo contexto de predio e andar" do
    bloco = i_blocos(:one)
    bloco_sem_ambientes = IBloco.create!(
      i_predio: bloco.i_predio,
      g_andar: bloco.g_andar,
      descricao: "Bloco Sem Ambientes",
      ativo: true
    )

    patch "/api/v1/i_predios/#{bloco.i_predio_id}/g_andares/#{bloco.g_andar_id}/i_blocos/#{bloco.id}",
          params: {
            i_bloco: {
              descricao: "Bloco Atualizado",
              ativo: true
            }
          }.to_json,
          headers: @headers

    assert_response :success
    assert_equal "Bloco Atualizado", bloco.reload.descricao

    assert_difference("IBloco.only_deleted.count", 1) do
      delete "/api/v1/i_predios/#{bloco_sem_ambientes.i_predio_id}/g_andares/#{bloco_sem_ambientes.g_andar_id}/i_blocos/#{bloco_sem_ambientes.id}",
             headers: @headers
    end

    assert_response :no_content
  end

  test "lista e cria ambientes por bloco" do
    bloco = i_blocos(:one)

    get "/api/v1/i_blocos/#{bloco.id}/i_ambientes_prediais", headers: @headers

    assert_response :success
    body = parse_response_body
    assert_equal [ i_ambientes_prediais(:one).id ], body.dig("data", "items").map { |item| item["id"] }

    assert_difference("IAmbientePredial.count", 1) do
      post "/api/v1/i_blocos/#{bloco.id}/i_ambientes_prediais",
           params: {
             i_ambiente_predial: {
               g_tipo_ambiente_predial_id: g_tipos_ambientes_prediais(:one).id,
               descricao: "Sala 01",
               comprimento: 6.5,
               largura: 4.5,
               metros_quadrados: 29.25,
               capacidade: 12,
               permite_reserva: true,
               ativo: true
             }
           }.to_json,
           headers: @headers
    end

    assert_response :created
    ambiente = IAmbientePredial.order(:id).last
    assert_equal bloco, ambiente.i_bloco
    assert_equal bloco.g_unidade_gestora, ambiente.g_unidade_gestora
  end

  test "atualiza e remove ambiente pelo contexto do bloco" do
    ambiente = i_ambientes_prediais(:one)

    patch "/api/v1/i_blocos/#{ambiente.i_bloco_id}/i_ambientes_prediais/#{ambiente.id}",
          params: {
            i_ambiente_predial: {
              descricao: "Sala Atualizada",
              capacidade: 20,
              permite_reserva: true
            }
          }.to_json,
          headers: @headers

    assert_response :success
    assert_equal "Sala Atualizada", ambiente.reload.descricao

    assert_difference("IAmbientePredial.only_deleted.count", 1) do
      delete "/api/v1/i_blocos/#{ambiente.i_bloco_id}/i_ambientes_prediais/#{ambiente.id}",
             headers: @headers
    end

    assert_response :no_content
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
