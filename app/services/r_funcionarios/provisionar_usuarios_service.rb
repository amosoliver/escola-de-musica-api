# frozen_string_literal: true

module RFuncionarios
  class ProvisionarUsuariosService
    def self.call(r_funcionario:)
      new(r_funcionario:).call
    end

    def initialize(r_funcionario:)
      @r_funcionario = r_funcionario
    end

    def call
      perfis = r_funcionario.perfis_de_acesso
      return Result.success(r_funcionario, HttpStatus::OK, "Nenhum perfil de acesso para provisionar") if perfis.empty?

      perfis.each do |perfil|
        result = GPessoas::CreateUsuarioService.call(
          g_pessoa: r_funcionario.g_pessoa,
          params: {
            email: r_funcionario.g_pessoa.email,
            u_perfil_id: perfil.id,
            g_unidade_gestora_id: r_funcionario.g_unidade_gestora_id,
            ativo: r_funcionario.ativo?
          }
        )
        return result if result.failure?
      end

      Result.success(r_funcionario, HttpStatus::OK, "Acessos do funcionario provisionados com sucesso")
    end

    private

    attr_reader :r_funcionario
  end
end
