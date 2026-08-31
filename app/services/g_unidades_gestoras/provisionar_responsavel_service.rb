# frozen_string_literal: true

module GUnidadesGestoras
  class ProvisionarResponsavelService
    def self.call(g_unidade_gestora:, params:)
      new(g_unidade_gestora:, params:).call
    end

    def initialize(g_unidade_gestora:, params:)
      @g_unidade_gestora = g_unidade_gestora
      @params = params || {}
    end

    def call
      return Result.success(nil, HttpStatus::OK) if params.blank?

      pessoa_result = resolver_pessoa
      return pessoa_result if pessoa_result.failure?

      g_pessoa = pessoa_result.value

      responsavel = build_responsavel(g_pessoa)
      return failure(responsavel) unless responsavel.save

      perfil = responsavel.perfil_de_acesso
      return failure_without_record("Informe um perfil valido para o responsavel da unidade") if perfil.blank?

      usuario_result = GPessoas::CreateUsuarioService.call(
        g_pessoa:,
        params: {
          email: g_pessoa.email,
          u_perfil_id: perfil.id,
          g_unidade_gestora_id: g_unidade_gestora.id,
          ativo: responsavel.ativo?
        }
      )
      return usuario_result if usuario_result.failure?

      g_unidade_gestora.update!(responsavel_nome: g_pessoa.nome)

      Result.success(responsavel, HttpStatus::OK, "Responsavel da unidade provisionado com sucesso")
    end

    private

    attr_reader :g_unidade_gestora, :params

    def resolver_pessoa
      GPessoas::ResolverPorCpfService.call(
        g_pessoa_id: params[:g_pessoa_id],
        g_pessoa_attributes: g_pessoa_params,
        atualizar_g_pessoa: params[:atualizar_g_pessoa]
      )
    end

    def build_responsavel(g_pessoa)
      record = if params[:id].present?
        g_unidade_gestora.g_unidades_gestoras_responsaveis.find(params[:id])
      else
        g_unidade_gestora.g_unidades_gestoras_responsaveis
                         .with_deleted
                         .find_or_initialize_by(g_pessoa:)
      end

      record.assign_attributes(
        g_pessoa:,
        r_funcao_id: params[:r_funcao_id],
        u_perfil_id: params[:u_perfil_id],
        principal: params.fetch(:principal, true),
        data_inicio: params[:data_inicio],
        data_fim: params[:data_fim],
        ativo: params.fetch(:ativo, true),
        deleted_at: nil
      )
      record
    end

    def g_pessoa_params
      (params[:g_pessoa_attributes] || {}).slice(
        :nome, :nome_social, :cpf, :data_nascimento, :g_sexo_id, :email, :telefone,
        :whatsapp, :foto, :cep, :logradouro, :numero, :g_bairro_id
      )
    end

    def failure(record)
      Result.failure(record.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY,
                     "Nao foi possivel provisionar o responsavel da unidade")
    end

    def failure_without_record(message)
      Result.failure(message, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel provisionar o responsavel da unidade")
    end
  end
end
