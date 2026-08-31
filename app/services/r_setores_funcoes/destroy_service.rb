# frozen_string_literal: true

module RSetoresFuncoes
  class DestroyService
    def self.call(r_setor_funcao:)
      new(r_setor_funcao:).call
    end

    def initialize(r_setor_funcao:)
      @r_setor_funcao = r_setor_funcao
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Vinculo setor-funcao removido com sucesso") if r_setor_funcao.destroy

      Result.failure(r_setor_funcao.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY,
                     "Nao foi possivel remover vinculo setor-funcao")
    end

    private

    attr_reader :r_setor_funcao
  end
end
