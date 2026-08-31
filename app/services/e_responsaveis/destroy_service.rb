# frozen_string_literal: true

module EResponsaveis
  class DestroyService
    def self.call(e_responsavel:)
      new(e_responsavel:).call
    end

    def initialize(e_responsavel:)
      @e_responsavel = e_responsavel
    end

    def call
      if e_responsavel.destroy
        return Result.success(nil, HttpStatus::NO_CONTENT, "Responsavel removido com sucesso")
      end

      Result.failure(e_responsavel.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover e responsavel")
    end

    private

    attr_reader :e_responsavel
  end
end
