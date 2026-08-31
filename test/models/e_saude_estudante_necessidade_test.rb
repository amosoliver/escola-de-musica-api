require "test_helper"

class ESaudeEstudanteNecessidadeTest < ActiveSupport::TestCase
  test "nao aceita data de laudo futura" do
    necessidade = ESaudeEstudanteNecessidade.new(
      e_saude_estudante: e_saudes_estudantes(:one),
      g_necessidade_especifica: g_necessidades_especificas(:two),
      data_laudo: Date.current + 1.day
    )

    assert_not necessidade.valid?
    assert_includes necessidade.errors[:data_laudo], "nao pode ser futura"
  end
end
