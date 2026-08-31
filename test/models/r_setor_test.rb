require "test_helper"

class RSetorTest < ActiveSupport::TestCase
  test "nao aceita setor pai de outra unidade gestora" do
    setor = RSetor.new(
      g_unidade_gestora: g_unidades_gestoras(:one),
      r_setor_pai: RSetor.new(g_unidade_gestora: g_unidades_gestoras(:two), codigo: "OUTRO", descricao: "Outro"),
      codigo: "NOVO_SETOR",
      descricao: "Novo Setor",
      ativo: true
    )

    assert_not setor.valid?
    assert_includes setor.errors[:r_setor_pai_id], "deve pertencer a mesma unidade gestora"
  end
end
