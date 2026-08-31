# frozen_string_literal: true

module EResponsaveis
  class UpdateService
    def self.call(e_responsavel:, params:)
      new(e_responsavel:, params:).call
    end

    def initialize(e_responsavel:, params:)
      @e_responsavel = e_responsavel
      @params = params
    end

    def call
      pessoa_result = nil

      ApplicationRecord.transaction do
        attributes = params.deep_dup
        pessoa_result = resolver_pessoa!(attributes)
        raise ActiveRecord::Rollback if pessoa_result.failure?

        raise ActiveRecord::Rollback unless e_responsavel.update(attributes)
      end

      return pessoa_result if pessoa_result.failure?
      return Result.success(e_responsavel, HttpStatus::OK, "Responsavel atualizado com sucesso") if e_responsavel.persisted? && e_responsavel.errors.empty?

      Result.failure(e_responsavel.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar e responsavel")
    end

    private

    attr_reader :e_responsavel, :params

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
