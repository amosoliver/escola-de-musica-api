# frozen_string_literal: true

module REspecialidades
  class DestroyService
    def self.call(r_especialidade:)
      new(r_especialidade:).call
    end

    def initialize(r_especialidade:)
      @r_especialidade = r_especialidade
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Especialidade removida com sucesso") if r_especialidade.destroy

      Result.failure(r_especialidade.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover r especialidade")
    end

    private

    attr_reader :r_especialidade
  end
end
