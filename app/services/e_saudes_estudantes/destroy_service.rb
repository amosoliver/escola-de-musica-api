# frozen_string_literal: true

module ESaudesEstudantes
  class DestroyService
    def self.call(e_saude_estudante:)
      new(e_saude_estudante:).call
    end

    def initialize(e_saude_estudante:)
      @e_saude_estudante = e_saude_estudante
    end

    def call
      if e_saude_estudante.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Saude do estudante removida com sucesso")
      end

      Result.failure(
        e_saude_estudante.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover e saude estudante"
      )
    end

    private

    attr_reader :e_saude_estudante
  end
end
