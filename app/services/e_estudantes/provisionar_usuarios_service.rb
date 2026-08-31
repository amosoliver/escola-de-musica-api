# frozen_string_literal: true

module EEstudantes
  class ProvisionarUsuariosService
    def self.call(e_estudante:, g_unidade_gestora_id:)
      new(e_estudante:, g_unidade_gestora_id:).call
    end

    def initialize(e_estudante:, g_unidade_gestora_id:)
      @e_estudante = e_estudante
      @g_unidade_gestora_id = g_unidade_gestora_id
    end

    def call
      return failure_without_record("Informe a unidade gestora para criar os acessos do estudante") if g_unidade_gestora_id.blank?

      result = provisionar_estudante
      return result if result.failure?

      result = provisionar_responsaveis
      return result if result.failure?

      Result.success(e_estudante, HttpStatus::OK, "Acessos provisionados com sucesso")
    end

    private

    attr_reader :e_estudante, :g_unidade_gestora_id

    def provisionar_estudante
      return Result.success(nil, HttpStatus::OK) unless e_estudante.acessa_portal?

      GPessoas::CreateUsuarioService.call(
        g_pessoa: e_estudante.g_pessoa,
        params: {
          email: e_estudante.g_pessoa.email,
          u_perfil_id: perfil_aluno_id,
          g_unidade_gestora_id:,
          ativo: true
        }
      )
    end

    def provisionar_responsaveis
      responsaveis_ativos.each do |vinculo|
        result = GPessoas::CreateUsuarioService.call(
          g_pessoa: vinculo.e_responsavel.g_pessoa,
          params: {
            email: vinculo.e_responsavel.g_pessoa.email,
            u_perfil_id: perfil_responsavel_legal_id,
            g_unidade_gestora_id:,
            ativo: vinculo.ativo?
          }
        )

        return result if result.failure?
      end

      Result.success(nil, HttpStatus::OK)
    end

    def responsaveis_ativos
      e_estudante.e_estudantes_responsaveis.includes(e_responsavel: :g_pessoa).select(&:ativo?)
    end

    def perfil_aluno_id
      @perfil_aluno_id ||= UPerfil.fetch_id_by_codigo!(UPerfil::ALUNO)
    end

    def perfil_responsavel_legal_id
      @perfil_responsavel_legal_id ||= UPerfil.fetch_id_by_codigo!(UPerfil::RESPONSAVEL_LEGAL)
    end

    def failure_without_record(message)
      Result.failure(message, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel provisionar acessos do estudante")
    end
  end
end
