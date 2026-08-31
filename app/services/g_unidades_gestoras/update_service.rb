# frozen_string_literal: true

module GUnidadesGestoras
  class UpdateService
    def self.call(g_unidade_gestora:, params:)
      new(g_unidade_gestora:, params:).call
    end

    def initialize(g_unidade_gestora:, params:)
      @g_unidade_gestora = g_unidade_gestora
      @params = params
    end

    def call
      responsavel_result = nil

      ApplicationRecord.transaction do
        unless g_unidade_gestora.update(unidade_params)
          responsavel_result = failure(g_unidade_gestora)
          raise ActiveRecord::Rollback
        end

        responsavel_result = GUnidadesGestoras::ProvisionarResponsavelService.call(
          g_unidade_gestora:,
          params: responsavel_params
        )
        raise ActiveRecord::Rollback if responsavel_result.failure?
      end

      return responsavel_result if responsavel_result&.failure?

      Result.success(
        g_unidade_gestora,
        HttpStatus::OK,
        "Unidade gestora atualizada com sucesso"
      )
    end

    private

    attr_reader :g_unidade_gestora, :params

    def unidade_params
      params.except(:g_unidade_gestora_responsavel_attributes)
    end

    def responsavel_params
      params[:g_unidade_gestora_responsavel_attributes]
    end

    def failure(record)
      Result.failure(
        record.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar g unidade gestora"
      )
    end
  end
end
