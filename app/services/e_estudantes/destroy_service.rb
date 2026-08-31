# frozen_string_literal: true

module EEstudantes
  class DestroyService
    def self.call(e_estudante:)
      new(e_estudante:).call
    end

    def initialize(e_estudante:)
      @e_estudante = e_estudante
    end

    def call
      if e_estudante.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Estudante removido com sucesso")
      end

      Result.failure(e_estudante.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover e estudante")
    end

    private

    attr_reader :e_estudante
  end
end
