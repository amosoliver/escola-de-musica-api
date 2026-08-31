# frozen_string_literal: true

module EEstudantes
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      e_estudante = nil
      pessoa_result = nil
      result = nil

      ApplicationRecord.transaction do
        attributes = estudante_params
        pessoa_result = resolver_pessoas!(attributes, required: true)
        raise ActiveRecord::Rollback if pessoa_result.failure?

        e_estudante = EEstudante.new(attributes)
        unless e_estudante.save
          result = failure(e_estudante)
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

      Result.success(e_estudante, HttpStatus::CREATED, "Estudante criado com sucesso")
    end

    private

    attr_reader :params

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

    def resolver_pessoas!(attributes, required:)
      result = resolver_pessoa!(attributes, required:)
      return result if result.failure?

      Array(attributes[:e_estudantes_responsaveis_attributes]).each do |responsavel_attributes|
        nested = responsavel_attributes[:e_responsavel_attributes]
        next unless nested.is_a?(Hash)

        result = resolver_pessoa!(nested, required: nested[:id].blank?)
        return result if result.failure?
      end

      Result.success(nil)
    end

    def resolver_pessoa!(attributes, required:)
      has_pessoa = attributes[:g_pessoa_id].present? || attributes[:g_pessoa_attributes].present?
      return Result.success(nil) unless required || has_pessoa

      result = GPessoas::ResolverPorCpfService.call(
        g_pessoa_id: attributes.delete(:g_pessoa_id),
        g_pessoa_attributes: attributes.delete(:g_pessoa_attributes),
        atualizar_g_pessoa: attributes.delete(:atualizar_g_pessoa)
      )
      attributes[:g_pessoa_id] = result.value.id if result.success?
      result
    end

    def failure(record)
      Result.failure(record.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar e estudante")
    end
  end
end
