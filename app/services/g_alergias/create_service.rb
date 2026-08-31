# frozen_string_literal: true

module GAlergias
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_alergia = GAlergia.new(params)

      if g_alergia.save
        return Result.success(g_alergia, HttpStatus::CREATED, "Alergia criada com sucesso")
      end

      Result.failure(g_alergia.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar g alergia")
    end

    private

    attr_reader :params
  end
end
