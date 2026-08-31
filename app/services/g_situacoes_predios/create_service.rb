# frozen_string_literal: true

module GSituacoesPredios
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_situacao_predio = GSituacaoPredio.new(params)

      if g_situacao_predio.save
        return Result.success(
          g_situacao_predio,
          HttpStatus::CREATED,
          "Situacao do predio criada com sucesso"
        )
      end

      Result.failure(
        g_situacao_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g situacao predio"
      )
    end

    private

    attr_reader :params
  end
end
