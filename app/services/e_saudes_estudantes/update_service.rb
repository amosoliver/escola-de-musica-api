# frozen_string_literal: true

module ESaudesEstudantes
  class UpdateService
    def self.call(e_saude_estudante:, params:)
      new(e_saude_estudante:, params:).call
    end

    def initialize(e_saude_estudante:, params:)
      @e_saude_estudante = e_saude_estudante
      @params = params
    end

    def call
      if e_saude_estudante.update(params)
        return Result.success(e_saude_estudante, HttpStatus::OK, "Saude do estudante atualizada com sucesso")
      end

      Result.failure(
        e_saude_estudante.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar e saude estudante"
      )
    end

    private

    attr_reader :e_saude_estudante, :params
  end
end
