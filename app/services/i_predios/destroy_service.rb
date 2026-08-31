# frozen_string_literal: true

module IPredios
  class DestroyService
    def self.call(i_predio:)
      new(i_predio:).call
    end

    def initialize(i_predio:)
      @i_predio = i_predio
    end

    def call
      if i_predio.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Predio removido com sucesso"
        )
      end

      Result.failure(
        i_predio.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover i predio"
      )
    end

    private

    attr_reader :i_predio
  end
end
