# frozen_string_literal: true

module IBlocos
  class DestroyService
    def self.call(i_bloco:)
      new(i_bloco:).call
    end

    def initialize(i_bloco:)
      @i_bloco = i_bloco
    end

    def call
      if i_bloco.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "I bloco removido com sucesso"
        )
      end

      Result.failure(
        i_bloco.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover i bloco"
      )
    end

    private

    attr_reader :i_bloco
  end
end
