# frozen_string_literal: true

module RFuncionarios
  class UpdateService
    def self.call(r_funcionario:, params:)
      new(r_funcionario:, params:).call
    end

    def initialize(r_funcionario:, params:)
      @r_funcionario = r_funcionario
      @params = params
    end

    def call
      pessoa_result = nil
      result = nil

      ApplicationRecord.transaction do
        attributes = params.deep_dup
        pessoa_result = resolver_pessoa!(attributes)
        raise ActiveRecord::Rollback if pessoa_result.failure?

        unless r_funcionario.update(attributes)
          result = failure
          raise ActiveRecord::Rollback
        end

        result = RFuncionarios::ProvisionarUsuariosService.call(r_funcionario:)
        raise ActiveRecord::Rollback if result.failure?
      end

      return pessoa_result if pessoa_result.failure?
      return result if result&.failure?

      Result.success(r_funcionario, HttpStatus::OK, "Funcionario atualizado com sucesso")
    end

    private

    attr_reader :r_funcionario, :params

    def failure
      Result.failure(r_funcionario.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar r funcionario")
    end

    def resolver_pessoa!(attributes)
      has_pessoa = attributes[:g_pessoa_id].present? || attributes[:g_pessoa_attributes].present?
      return Result.success(nil) unless has_pessoa

      result = GPessoas::ResolverPorCpfService.call(
        g_pessoa_id: attributes.delete(:g_pessoa_id),
        g_pessoa_attributes: attributes.delete(:g_pessoa_attributes),
        atualizar_g_pessoa: attributes.delete(:atualizar_g_pessoa)
      )
      attributes[:g_pessoa_id] = result.value.id if result.success?
      result
    end
  end
end
