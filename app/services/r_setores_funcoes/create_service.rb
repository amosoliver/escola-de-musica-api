# frozen_string_literal: true

module RSetoresFuncoes
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      r_setor_funcao = RSetorFuncao.new(params)
      return Result.success(r_setor_funcao, HttpStatus::CREATED, "Vinculo setor-funcao criado com sucesso") if r_setor_funcao.save

      Result.failure(r_setor_funcao.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY,
                     "Nao foi possivel criar vinculo setor-funcao")
    end

    private

    attr_reader :params
  end
end
