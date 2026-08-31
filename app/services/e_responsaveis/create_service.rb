# frozen_string_literal: true

module EResponsaveis
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      e_responsavel = nil
      pessoa_result = nil

      ApplicationRecord.transaction do
        attributes = params.deep_dup
        pessoa_result = resolver_pessoa!(attributes)
        raise ActiveRecord::Rollback if pessoa_result.failure?

        e_responsavel = EResponsavel.new(attributes)
        raise ActiveRecord::Rollback unless e_responsavel.save
      end

      return pessoa_result if pessoa_result.failure?
      return Result.success(e_responsavel, HttpStatus::CREATED, "Responsavel criado com sucesso") if e_responsavel.persisted?

      Result.failure(e_responsavel.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar e responsavel")
    end

    private

    attr_reader :params

    def resolver_pessoa!(attributes)
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
