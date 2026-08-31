# frozen_string_literal: true

module GUnidadesGestoras
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_unidade_gestora = GUnidadeGestora.new(unidade_params)
      responsavel_result = nil

      ApplicationRecord.transaction do
        unless g_unidade_gestora.save
          responsavel_result = failure(g_unidade_gestora)
          raise ActiveRecord::Rollback
        end

        if responsavel_obrigatorio? && responsavel_params.blank?
          responsavel_result = failure_without_record("Informe o responsavel inicial da unidade gestora")
          raise ActiveRecord::Rollback
        end

        Importacao::Referenciais.populate_setores_for_unidade(unidade: g_unidade_gestora) if g_unidade_gestora.tipo_unidade == GTipoUnidadeGestora::ESCOLA

        responsavel_result = GUnidadesGestoras::ProvisionarResponsavelService.call(
          g_unidade_gestora:,
          params: responsavel_params
        )
        raise ActiveRecord::Rollback if responsavel_result.failure?
      end

      return responsavel_result if responsavel_result&.failure?

      Result.success(
        g_unidade_gestora,
        HttpStatus::CREATED,
        "Unidade gestora criada com sucesso"
      )
    end

    private

    attr_reader :params

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
        "Nao foi possivel criar g unidade gestora"
      )
    end

    def failure_without_record(message)
      Result.failure(message, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar g unidade gestora")
    end

    def responsavel_obrigatorio?
      g_tipo = unidade_params[:g_tipo_unidade_gestora_id]
      codigo = unidade_params[:tipo_unidade]
      codigo == GTipoUnidadeGestora::ESCOLA ||
        GTipoUnidadeGestora.where(id: g_tipo).pick(:codigo) == GTipoUnidadeGestora::ESCOLA
    end
  end
end
