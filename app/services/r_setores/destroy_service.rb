# frozen_string_literal: true

module RSetores
  class DestroyService
    def self.call(r_setor:)
      new(r_setor:).call
    end

    def initialize(r_setor:)
      @r_setor = r_setor
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Setor removido com sucesso") if r_setor.destroy

      Result.failure(r_setor.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover r setor")
    end

    private

    attr_reader :r_setor
  end
end
