# frozen_string_literal: true

module RFuncoes
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      r_funcao = RFuncao.new(params)
      return Result.success(r_funcao, HttpStatus::CREATED, "Funcao criada com sucesso") if r_funcao.save

      Result.failure(r_funcao.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar r funcao")
    end

    private

    attr_reader :params
  end
end
