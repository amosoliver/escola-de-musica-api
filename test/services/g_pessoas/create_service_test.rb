require "test_helper"

class GPessoas::CreateServiceTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "cria pessoa com usuario e perfil" do
    params = {
      nome: "Maria da Silva",
      cpf: "123.456.789-09",
      data_nascimento: Date.new(1990, 1, 1),
      g_sexo_id: g_sexos(:one).id,
      email: "maria@example.com",
      u_perfil_id: u_perfis(:one).id,
      g_unidade_gestora_id: g_unidades_gestoras(:two).id,
      ativo: true
    }

    result = GPessoas::CreateService.call(params:)

    assert result.success?
    assert_equal 1, User.where(g_pessoa: result.value).count

    user = User.find_by!(g_pessoa: result.value)
    assert_equal "12345678909", user.cpf
    assert_equal "maria@example.com", user.email

    vinculo = UserPerfil.find_by!(user:)
    assert_equal u_perfis(:one), vinculo.u_perfil
    assert_equal g_unidades_gestoras(:two), vinculo.g_unidade_gestora
    assert vinculo.ativo?
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal "Defina sua senha de acesso", ActionMailer::Base.deliveries.last.subject
  end

  test "faz rollback da pessoa quando usuario eh invalido" do
    params = {
      nome: "Joao da Silva",
      cpf: "123.456.789-08",
      data_nascimento: Date.new(1991, 1, 1),
      g_sexo_id: g_sexos(:one).id,
      u_perfil_id: u_perfis(:one).id,
      g_unidade_gestora_id: g_unidades_gestoras(:two).id
    }

    assert_no_difference("GPessoa.count") do
      result = GPessoas::CreateService.call(params:)

      assert result.failure?
    end
  end
end
