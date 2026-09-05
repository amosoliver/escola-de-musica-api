# frozen_string_literal: true

require "test_helper"

class Api::V1::PInventariosFluxoTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Authorization" => "Bearer #{access_token_for(users(:one))}",
      "Content-Type" => "application/json"
    }
    @g_unidade_gestora = g_unidades_gestoras(:one)
    @i_ambiente_predial = i_ambientes_prediais(:one)
    @situacao_disponivel = PSituacaoPatrimonio.find_or_create_by!(codigo: "DISPONIVEL") do |s|
      s.descricao = "Disponivel"
      s.permite_emprestimo = true
      s.permite_movimentacao = true
    end
    @estado_bom = PEstadoConservacaoPatrimonio.find_or_create_by!(codigo: "BOM") { |e| e.descricao = "Bom"; e.ordem = 3 }

    @patrimonio = PPatrimonio.create!(
      g_unidade_gestora: @g_unidade_gestora,
      p_situacao_patrimonio: @situacao_disponivel,
      p_estado_conservacao_patrimonio: @estado_bom,
      i_ambiente_predial: @i_ambiente_predial,
      codigo_patrimonial: "PAT-INV-001",
      descricao: "Cadeira"
    )
  end

  test "cria inventario com itens pre-populados pelo escopo, confere um item e encerra" do
    assert_difference("PInventario.count", 1) do
      post "/api/v1/p_inventarios",
           params: {
             g_unidade_gestora_id: @g_unidade_gestora.id,
             descricao: "Inventario Sala de Piano 01",
             r_funcionario_responsavel_id: r_funcionarios(:one).id,
             i_ambiente_predial_id: @i_ambiente_predial.id
           }.to_json,
           headers: @headers
    end

    assert_response :created
    inventario = PInventario.last
    assert_equal 1, inventario.p_inventarios_itens.count
    item = inventario.p_inventarios_itens.find_by!(p_patrimonio: @patrimonio)
    assert_not item.encontrado

    patch "/api/v1/p_inventarios/#{inventario.id}/p_inventarios_itens/#{item.id}",
          params: {
            encontrado: true,
            i_ambiente_predial_encontrado_id: @i_ambiente_predial.id,
            p_estado_conservacao_patrimonio_id: @estado_bom.id
          }.to_json,
          headers: @headers

    assert_response :success
    item.reload
    assert item.encontrado
    assert_not item.localizacao_divergente
    assert_not_nil item.conferido_em

    post "/api/v1/p_inventarios/#{inventario.id}/encerrar", headers: @headers

    assert_response :success
    assert_predicate inventario.reload, :encerrado?
    assert_not_nil inventario.data_fim
  end

  private

  def access_token_for(user)
    Auth::JsonWebToken.encode(sub: user.id, typ: "access", exp: 1.day.from_now.to_i)
  end
end
