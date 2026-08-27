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
      g_unidade_gestora = GUnidadeGestora.new(params)

      if g_unidade_gestora.save
        return Result.success(
          g_unidade_gestora,
          HttpStatus::CREATED,
          "G unidade gestora criado com sucesso"
        )
      end

      Result.failure(
        g_unidade_gestora.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g unidade gestora"
      )
    end

    private

    attr_reader :params
  end
end
