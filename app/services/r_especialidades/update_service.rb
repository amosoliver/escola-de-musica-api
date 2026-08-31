# frozen_string_literal: true

module REspecialidades
  class UpdateService
    def self.call(r_especialidade:, params:)
      new(r_especialidade:, params:).call
    end

    def initialize(r_especialidade:, params:)
      @r_especialidade = r_especialidade
      @params = params
    end

    def call
      return Result.success(r_especialidade, HttpStatus::OK, "Especialidade atualizada com sucesso") if r_especialidade.update(params)

      Result.failure(r_especialidade.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar r especialidade")
    end

    private

    attr_reader :r_especialidade, :params
  end
end
