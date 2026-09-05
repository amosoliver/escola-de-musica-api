# frozen_string_literal: true

module PDestinosExternos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      p_destino_externo = PDestinoExterno.new(params)
      return Result.success(p_destino_externo, HttpStatus::CREATED, "Destino externo criado com sucesso") if p_destino_externo.save

      Result.failure(p_destino_externo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar destino externo")
    end

    private

    attr_reader :params
  end
end
