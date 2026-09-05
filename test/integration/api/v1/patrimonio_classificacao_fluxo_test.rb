# frozen_string_literal: true

require "test_helper"

class Api::V1::PatrimonioClassificacaoFluxoTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Authorization" => "Bearer #{access_token_for(users(:one))}",
      "Content-Type" => "application/json"
    }
    @g_unidade_gestora = g_unidades_gestoras(:one)
    @p_situacao_disponivel = PSituacaoPatrimonio.find_or_create_by!(codigo: "DISPONIVEL") do |s|
      s.descricao = "Disponivel"
      s.permite_emprestimo = true
      s.permite_movimentacao = true
    end
    @p_estado_bom = PEstadoConservacaoPatrimonio.find_or_create_by!(codigo: "BOM") do |e|
      e.descricao = "Bom"
      e.ordem = 3
    end
  end

  test "cadastra patrimonio criando tipo e categoria patrimonial na hora (formulario aninhado)" do
    assert_difference(-> { GCategoriaPatrimonio.count } => 1, -> { GTipoPatrimonio.count } => 1, -> { PPatrimonio.count } => 1) do
      post "/api/v1/p_patrimonios",
           params: {
             p_patrimonio: {
               g_unidade_gestora_id: @g_unidade_gestora.id,
               p_situacao_patrimonio_id: @p_situacao_disponivel.id,
               p_estado_conservacao_patrimonio_id: @p_estado_bom.id,
               codigo_patrimonial: "PAT-CLASS-001",
               descricao: "Mesa de escritorio",
               g_tipo_patrimonio_attributes: {
                 codigo: "MOBILIARIO",
                 descricao: "Mobiliario",
                 representa_instrumento: false,
                 g_categoria_patrimonio_attributes: { codigo: "MOVEIS_UTENSILIOS", descricao: "Moveis e utensilios" }
               }
             }
           }.to_json,
           headers: @headers
    end

    assert_response :created
    patrimonio = PPatrimonio.find_by!(codigo_patrimonial: "PAT-CLASS-001")
    assert_equal "MOBILIARIO", patrimonio.g_tipo_patrimonio.codigo
    assert_equal "MOVEIS_UTENSILIOS", patrimonio.g_categoria_patrimonio.codigo
  end

  test "cadastra patrimonio reaproveitando tipo patrimonial ja existente" do
    tipo = GTipoPatrimonio.find_by(codigo: "INSTRUMENTO") || GTipoPatrimonio.create!(
      codigo: "INSTRUMENTO", descricao: "Instrumento", representa_instrumento: true,
      g_categoria_patrimonio: GCategoriaPatrimonio.find_or_create_by!(codigo: "INSTRUMENTO_MUSICAL") { |c| c.descricao = "Instrumento musical" }
    )

    assert_no_difference [ "GCategoriaPatrimonio.count", "GTipoPatrimonio.count" ] do
      assert_difference("PPatrimonio.count", 1) do
        post "/api/v1/p_patrimonios",
             params: {
               p_patrimonio: {
                 g_unidade_gestora_id: @g_unidade_gestora.id,
                 p_situacao_patrimonio_id: @p_situacao_disponivel.id,
                 p_estado_conservacao_patrimonio_id: @p_estado_bom.id,
                 codigo_patrimonial: "PAT-CLASS-002",
                 descricao: "Piano Yamaha C3",
                 g_tipo_patrimonio_id: tipo.id
               }
             }.to_json,
             headers: @headers
      end
    end

    assert_response :created
    patrimonio = PPatrimonio.find_by!(codigo_patrimonial: "PAT-CLASS-002")
    assert_equal tipo.id, patrimonio.g_tipo_patrimonio_id
  end

  private

  def access_token_for(user)
    Auth::JsonWebToken.encode(sub: user.id, typ: "access", exp: 1.day.from_now.to_i)
  end
end
