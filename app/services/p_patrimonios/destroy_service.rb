# frozen_string_literal: true

module PPatrimonios
  class DestroyService
    def self.call(p_patrimonio:)
      new(p_patrimonio:).call
    end

    def initialize(p_patrimonio:)
      @p_patrimonio = p_patrimonio
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Patrimonio removido com sucesso") if p_patrimonio.destroy

      Result.failure(p_patrimonio.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover patrimonio")
    end

    private

    attr_reader :p_patrimonio
  end
end
