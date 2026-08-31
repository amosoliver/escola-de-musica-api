# frozen_string_literal: true

module RFuncionarios
  class DestroyService
    def self.call(r_funcionario:)
      new(r_funcionario:).call
    end

    def initialize(r_funcionario:)
      @r_funcionario = r_funcionario
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Funcionario removido com sucesso") if r_funcionario.destroy

      Result.failure(r_funcionario.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover r funcionario")
    end

    private

    attr_reader :r_funcionario
  end
end
