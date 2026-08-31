# frozen_string_literal: true

module REspecialidades
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      r_especialidade = REspecialidade.new(params)
      return Result.success(r_especialidade, HttpStatus::CREATED, "Especialidade criada com sucesso") if r_especialidade.save

      Result.failure(r_especialidade.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar r especialidade")
    end

    private

    attr_reader :params
  end
end
