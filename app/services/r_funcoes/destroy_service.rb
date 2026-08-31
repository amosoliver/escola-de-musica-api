# frozen_string_literal: true

module RFuncoes
  class DestroyService
    def self.call(r_funcao:)
      new(r_funcao:).call
    end

    def initialize(r_funcao:)
      @r_funcao = r_funcao
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Funcao removida com sucesso") if r_funcao.destroy

      Result.failure(r_funcao.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover r funcao")
    end

    private

    attr_reader :r_funcao
  end
end
