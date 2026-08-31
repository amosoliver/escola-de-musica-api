# frozen_string_literal: true

module RSetoresFuncoes
  class UpdateService
    def self.call(r_setor_funcao:, params:)
      new(r_setor_funcao:, params:).call
    end

    def initialize(r_setor_funcao:, params:)
      @r_setor_funcao = r_setor_funcao
      @params = params
    end

    def call
      return Result.success(r_setor_funcao, HttpStatus::OK, "Vinculo setor-funcao atualizado com sucesso") if r_setor_funcao.update(params)

      Result.failure(r_setor_funcao.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY,
                     "Nao foi possivel atualizar vinculo setor-funcao")
    end

    private

    attr_reader :r_setor_funcao, :params
  end
end
