require "test_helper"

class EEstudanteResponsavelTest < ActiveSupport::TestCase
  test "exige parentesco_outro quando parentesco permite outro" do
    vinculo = EEstudanteResponsavel.new(
      e_estudante: e_estudantes(:one),
      e_responsavel: e_responsaveis(:one),
      g_parentesco: g_parentescos(:two)
    )

    assert_not vinculo.valid?
    assert_includes vinculo.errors[:parentesco_outro], "deve ser informado"
  end

  test "valida periodo do vinculo" do
    vinculo = EEstudanteResponsavel.new(
      e_estudante: e_estudantes(:one),
      e_responsavel: e_responsaveis(:one),
      g_parentesco: g_parentescos(:one),
      data_inicio: Date.new(2026, 8, 10),
      data_fim: Date.new(2026, 8, 1)
    )

    assert_not vinculo.valid?
    assert_includes vinculo.errors[:data_fim], "deve ser maior ou igual a data de inicio"
  end
end
