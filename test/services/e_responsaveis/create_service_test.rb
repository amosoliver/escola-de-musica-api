# frozen_string_literal: true

require "test_helper"

class EResponsaveis::CreateServiceTest < ActiveSupport::TestCase
  test "reutiliza a pessoa existente pelo CPF sem sobrescrever seus dados" do
    pessoa = g_pessoas(:one)

    assert_no_difference("GPessoa.count") do
      assert_difference("EResponsavel.count", 1) do
        result = EResponsaveis::CreateService.call(
          params: {
            g_unidade_gestora_id: g_unidades_gestoras(:one).id,
            g_pessoa_attributes: {
              cpf: pessoa.cpf,
              nome: "Nome nao aplicado"
            }
          }
        )

        assert result.success?
        assert_equal pessoa, result.value.g_pessoa
      end
    end

    assert_equal "MyString", pessoa.reload.nome
  end
end
