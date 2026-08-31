# frozen_string_literal: true

module GPessoas
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      pessoa_result = nil
      g_pessoa = nil
      usuario_result = nil

      ApplicationRecord.transaction do
        pessoa_result = GPessoas::ResolverPorCpfService.call(
          g_pessoa_id: nil,
          g_pessoa_attributes: g_pessoa_params,
          atualizar_g_pessoa: params[:atualizar_g_pessoa]
        )
        raise ActiveRecord::Rollback if pessoa_result.failure?

        g_pessoa = pessoa_result.value
        usuario_result = GPessoas::CreateUsuarioService.call(g_pessoa:, params: usuario_params)
        raise ActiveRecord::Rollback if usuario_result.failure?
      end

      return pessoa_result if pessoa_result.failure?

      if g_pessoa&.persisted? && usuario_result&.success?
        return Result.success(
          g_pessoa,
          pessoa_result.status,
          pessoa_result.message
        )
      end

      return usuario_result if usuario_result&.failure?

      Result.failure(
        g_pessoa&.errors&.full_messages || [],
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g pessoa"
      )
    end

    private

    attr_reader :params

    def g_pessoa_params
      params.except(:atualizar_g_pessoa, :u_perfil_id, :g_unidade_gestora_id, :ativo)
    end

    def usuario_params
      params.slice(:email, :u_perfil_id, :g_unidade_gestora_id, :ativo)
    end
  end
end
