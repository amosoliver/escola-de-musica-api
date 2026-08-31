# frozen_string_literal: true

module GParentescos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_parentesco = GParentesco.new(params)

      if g_parentesco.save
        return Result.success(g_parentesco, HttpStatus::CREATED, "Parentesco criado com sucesso")
      end

      Result.failure(g_parentesco.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar g parentesco")
    end

    private

    attr_reader :params
  end
end
