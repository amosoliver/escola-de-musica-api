# frozen_string_literal: true

module RFuncionarios
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      r_funcionario = nil
      pessoa_result = nil
      result = nil

      ApplicationRecord.transaction do
        attributes = params.deep_dup
        pessoa_result = resolver_pessoa!(attributes)
        raise ActiveRecord::Rollback if pessoa_result.failure?

        r_funcionario = RFuncionario.new(attributes)
        unless r_funcionario.save
          result = failure(r_funcionario)
          raise ActiveRecord::Rollback
        end

        result = RFuncionarios::SincronizarFuncoesLegadasService.call(r_funcionario:)
        raise ActiveRecord::Rollback if result.failure?

        result = RFuncionarios::ProvisionarUsuariosService.call(r_funcionario:)
        raise ActiveRecord::Rollback if result.failure?
      end

      return pessoa_result if pessoa_result.failure?
      return result if result&.failure?

      Result.success(r_funcionario, HttpStatus::CREATED, "Funcionario criado com sucesso")
    end

    private

    def failure(r_funcionario)
      Result.failure(r_funcionario.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar r funcionario")
    end

    def resolver_pessoa!(attributes)
      result = GPessoas::ResolverPorCpfService.call(
        g_pessoa_id: attributes.delete(:g_pessoa_id),
        g_pessoa_attributes: attributes.delete(:g_pessoa_attributes),
        atualizar_g_pessoa: attributes.delete(:atualizar_g_pessoa)
      )
      attributes[:g_pessoa_id] = result.value.id if result.success?
      result
    end

    attr_reader :params
  end
end
