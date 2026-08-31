# frozen_string_literal: true

module GNecessidadesEspecificas
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_necessidade_especifica = GNecessidadeEspecifica.new(params)

      if g_necessidade_especifica.save
        return Result.success(g_necessidade_especifica, HttpStatus::CREATED, "Necessidade especifica criada com sucesso")
      end

      Result.failure(
        g_necessidade_especifica.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g necessidade especifica"
      )
    end

    private

    attr_reader :params
  end
end
