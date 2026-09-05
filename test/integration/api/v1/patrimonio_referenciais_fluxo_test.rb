# frozen_string_literal: true

require "test_helper"

class Api::V1::PatrimonioReferenciaisFluxoTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Authorization" => "Bearer #{access_token_for(users(:one))}",
      "Content-Type" => "application/json"
    }
  end

  test "cria, atualiza, lista e remove uma situacao de patrimonio" do
    assert_difference("PSituacaoPatrimonio.count", 1) do
      post "/api/v1/p_situacoes_patrimonios",
           params: { p_situacao_patrimonio: { codigo: "RESERVADO", descricao: "Reservado", permite_emprestimo: false, permite_movimentacao: true, ativo: true } }.to_json,
           headers: @headers
    end

    assert_response :created
    situacao = PSituacaoPatrimonio.find_by!(codigo: "RESERVADO")

    patch "/api/v1/p_situacoes_patrimonios/#{situacao.id}",
          params: { p_situacao_patrimonio: { descricao: "Reservado para uso" } }.to_json,
          headers: @headers

    assert_response :success
    assert_equal "Reservado para uso", situacao.reload.descricao

    get "/api/v1/p_situacoes_patrimonios", headers: @headers

    assert_response :success
    assert_includes parse_response_body.dig("data", "items").map { |item| item["codigo"] }, "RESERVADO"

    delete "/api/v1/p_situacoes_patrimonios/#{situacao.id}", headers: @headers

    assert_response :no_content
    assert_predicate situacao.reload, :deleted?
  end

  test "rejeita tipo de movimentacao com destinos interno e externo" do
    assert_no_difference("PTipoMovimentacaoPatrimonio.count") do
      post "/api/v1/p_tipos_movimentacoes_patrimonios",
           params: { p_tipo_movimentacao_patrimonio: { codigo: "INVALIDO", descricao: "Invalido", destino_interno: true, destino_externo: true, movimentacao_definitiva: false, ativo: true } }.to_json,
           headers: @headers
    end

    assert_response :unprocessable_entity
  end

  private

  def access_token_for(user)
    Auth::JsonWebToken.encode(sub: user.id, typ: "access", exp: 1.day.from_now.to_i)
  end
end
