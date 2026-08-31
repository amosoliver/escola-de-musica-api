# frozen_string_literal: true

module RFuncoes
  class UpdateService
    def self.call(r_funcao:, params:)
      new(r_funcao:, params:).call
    end

    def initialize(r_funcao:, params:)
      @r_funcao = r_funcao
      @params = params
    end

    def call
      return Result.success(r_funcao, HttpStatus::OK, "Funcao atualizada com sucesso") if r_funcao.update(params)

      Result.failure(r_funcao.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar r funcao")
    end

    private

    attr_reader :r_funcao, :params
  end
end
