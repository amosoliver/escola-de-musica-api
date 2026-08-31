# frozen_string_literal: true

module RSetores
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      r_setor = RSetor.new(params)
      return Result.success(r_setor, HttpStatus::CREATED, "Setor criado com sucesso") if r_setor.save

      Result.failure(r_setor.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar r setor")
    end

    private

    attr_reader :params
  end
end
