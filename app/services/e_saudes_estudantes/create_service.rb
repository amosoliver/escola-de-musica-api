# frozen_string_literal: true

module ESaudesEstudantes
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      e_saude_estudante = ESaudeEstudante.new(params)

      if e_saude_estudante.save
        return Result.success(e_saude_estudante, HttpStatus::CREATED, "Saude do estudante criada com sucesso")
      end

      Result.failure(
        e_saude_estudante.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar e saude estudante"
      )
    end

    private

    attr_reader :params
  end
end
