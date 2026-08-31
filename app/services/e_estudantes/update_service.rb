# frozen_string_literal: true

module EEstudantes
  class UpdateService
    def self.call(e_estudante:, params:)
      new(e_estudante:, params:).call
    end

    def initialize(e_estudante:, params:)
      @e_estudante = e_estudante
      @params = params
    end

    def call
      pessoa_result = nil
      result = nil

      ApplicationRecord.transaction do
        attributes = estudante_params
        pessoa_result = resolver_pessoas!(attributes)
        raise ActiveRecord::Rollback if pessoa_result.failure?

        unless e_estudante.update(attributes)
          result = failure
          raise ActiveRecord::Rollback
        end

        result = EEstudantes::ProvisionarUsuariosService.call(
          e_estudante:,
          g_unidade_gestora_id: access_g_unidade_gestora_id
        )
        raise ActiveRecord::Rollback if result.failure?
      end

      return pessoa_result if pessoa_result.failure?
      return result if result&.failure?

      Result.success(e_estudante, HttpStatus::OK, "Estudante atualizado com sucesso")
    end

    private

    attr_reader :e_estudante, :params

    def estudante_params
      attributes = params.deep_dup
      unidade_id = attributes[:g_unidade_gestora_id]

      Array(attributes[:e_estudantes_responsaveis_attributes]).each do |responsavel_attributes|
        nested = responsavel_attributes[:e_responsavel_attributes]
        next unless nested.is_a?(Hash)

        nested[:g_unidade_gestora_id] = unidade_id
      end

      attributes
    end

    def access_g_unidade_gestora_id
      params[:g_unidade_gestora_id]
    end

    def resolver_pessoas!(attributes)
      result = resolver_pessoa!(attributes)
      return result if result.failure?

      Array(attributes[:e_estudantes_responsaveis_attributes]).each do |responsavel_attributes|
        nested = responsavel_attributes[:e_responsavel_attributes]
        next unless nested.is_a?(Hash)

        result = resolver_pessoa!(nested)
        return result if result.failure?
      end

      Result.success(nil)
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

    def failure
      Result.failure(e_estudante.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar e estudante")
    end
  end
end
