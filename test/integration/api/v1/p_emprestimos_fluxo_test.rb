# frozen_string_literal: true

require "test_helper"

class Api::V1::PEmprestimosFluxoTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {
      "Authorization" => "Bearer #{access_token_for(users(:one))}",
      "Content-Type" => "application/json"
    }
    @g_unidade_gestora = g_unidades_gestoras(:one)
    @situacao_disponivel = PSituacaoPatrimonio.find_or_create_by!(codigo: "DISPONIVEL") do |s|
      s.descricao = "Disponivel"
      s.permite_emprestimo = true
      s.permite_movimentacao = true
    end
    PSituacaoPatrimonio.find_or_create_by!(codigo: "EMPRESTADO") do |s|
      s.descricao = "Emprestado"
      s.permite_emprestimo = false
      s.permite_movimentacao = true
    end
    @estado_bom = PEstadoConservacaoPatrimonio.find_or_create_by!(codigo: "BOM") { |e| e.descricao = "Bom"; e.ordem = 3 }
    @estado_regular = PEstadoConservacaoPatrimonio.find_or_create_by!(codigo: "REGULAR") { |e| e.descricao = "Regular"; e.ordem = 4 }
    PStatusEmprestimoPatrimonio.find_or_create_by!(codigo: "ABERTO") { |s| s.descricao = "Aberto"; s.finalizador = false }
    PStatusEmprestimoPatrimonio.find_or_create_by!(codigo: "PARCIALMENTE_DEVOLVIDO") { |s| s.descricao = "Parcialmente devolvido"; s.finalizador = false }
    PStatusEmprestimoPatrimonio.find_or_create_by!(codigo: "DEVOLVIDO") { |s| s.descricao = "Devolvido"; s.finalizador = true }

    @violino = criar_patrimonio("PAT-EMP-001", "Violino")
    @arco = criar_patrimonio("PAT-EMP-002", "Arco")
  end

  test "abre emprestimo com dois itens, devolve um sem avaria e outro com avaria" do
    assert_difference("PEmprestimo.count", 1) do
      post "/api/v1/p_emprestimos",
           params: {
             g_unidade_gestora_id: @g_unidade_gestora.id,
             g_pessoa_id: g_pessoas(:two).id,
             r_funcionario_entrega_id: r_funcionarios(:one).id,
             data_prevista_devolucao: 7.days.from_now,
             p_emprestimos_itens_attributes: [
               { p_patrimonio_id: @violino.id, p_estado_conservacao_patrimonio_id: @estado_bom.id },
               { p_patrimonio_id: @arco.id, p_estado_conservacao_patrimonio_id: @estado_bom.id }
             ]
           }.to_json,
           headers: @headers
    end

    assert_response :created
    emprestimo = PEmprestimo.last
    assert_equal "ABERTO", emprestimo.p_status_emprestimo_patrimonio.codigo
    assert_equal "EMPRESTADO", @violino.reload.p_situacao_patrimonio.codigo
    assert_equal "EMPRESTADO", @arco.reload.p_situacao_patrimonio.codigo

    violino_item = emprestimo.p_emprestimos_itens.find_by!(p_patrimonio: @violino)
    arco_item = emprestimo.p_emprestimos_itens.find_by!(p_patrimonio: @arco)

    post "/api/v1/p_emprestimos/#{emprestimo.id}/p_devolucoes",
         params: {
           r_funcionario_recebimento_id: r_funcionarios(:one).id,
           p_devolucoes_itens_attributes: [
             { p_emprestimo_item_id: violino_item.id, p_estado_conservacao_patrimonio_id: @estado_bom.id, possui_avaria: false }
           ]
         }.to_json,
         headers: @headers

    assert_response :created
    assert_equal "DISPONIVEL", @violino.reload.p_situacao_patrimonio.codigo
    assert_equal "PARCIALMENTE_DEVOLVIDO", emprestimo.reload.p_status_emprestimo_patrimonio.codigo

    post "/api/v1/p_emprestimos/#{emprestimo.id}/p_devolucoes",
         params: {
           r_funcionario_recebimento_id: r_funcionarios(:one).id,
           p_devolucoes_itens_attributes: [
             { p_emprestimo_item_id: arco_item.id, p_estado_conservacao_patrimonio_id: @estado_regular.id, possui_avaria: true }
           ]
         }.to_json,
         headers: @headers

    assert_response :unprocessable_entity

    post "/api/v1/p_emprestimos/#{emprestimo.id}/p_devolucoes",
         params: {
           r_funcionario_recebimento_id: r_funcionarios(:one).id,
           p_devolucoes_itens_attributes: [
             {
               p_emprestimo_item_id: arco_item.id, p_estado_conservacao_patrimonio_id: @estado_regular.id,
               possui_avaria: true, descricao_avaria: "Ponta danificada"
             }
           ]
         }.to_json,
         headers: @headers

    assert_response :created
    assert_equal "DISPONIVEL", @arco.reload.p_situacao_patrimonio.codigo
    assert_equal "DEVOLVIDO", emprestimo.reload.p_status_emprestimo_patrimonio.codigo
  end

  private

  def criar_patrimonio(codigo, descricao)
    PPatrimonio.create!(
      g_unidade_gestora: @g_unidade_gestora,
      p_situacao_patrimonio: @situacao_disponivel,
      p_estado_conservacao_patrimonio: @estado_bom,
      codigo_patrimonial: codigo,
      descricao: descricao
    )
  end

  def access_token_for(user)
    Auth::JsonWebToken.encode(sub: user.id, typ: "access", exp: 1.day.from_now.to_i)
  end
end
