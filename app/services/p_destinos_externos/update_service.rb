# frozen_string_literal: true

module PDestinosExternos
  class UpdateService
    def self.call(p_destino_externo:, params:)
      new(p_destino_externo:, params:).call
    end

    def initialize(p_destino_externo:, params:)
      @p_destino_externo = p_destino_externo
      @params = params
    end

    def call
      return Result.success(p_destino_externo, HttpStatus::OK, "Destino externo atualizado com sucesso") if p_destino_externo.update(params)

      Result.failure(p_destino_externo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar destino externo")
    end

    private

    attr_reader :p_destino_externo, :params
  end
end
