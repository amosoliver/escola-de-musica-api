# frozen_string_literal: true

module PDestinosExternos
  class DestroyService
    def self.call(p_destino_externo:)
      new(p_destino_externo:).call
    end

    def initialize(p_destino_externo:)
      @p_destino_externo = p_destino_externo
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Destino externo removido com sucesso") if p_destino_externo.destroy

      Result.failure(p_destino_externo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover destino externo")
    end

    private

    attr_reader :p_destino_externo
  end
end
