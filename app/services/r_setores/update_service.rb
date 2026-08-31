# frozen_string_literal: true

module RSetores
  class UpdateService
    def self.call(r_setor:, params:)
      new(r_setor:, params:).call
    end

    def initialize(r_setor:, params:)
      @r_setor = r_setor
      @params = params
    end

    def call
      return Result.success(r_setor, HttpStatus::OK, "Setor atualizado com sucesso") if r_setor.update(params)

      Result.failure(r_setor.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY,
                     "Nao foi possivel atualizar r setor")
    end

    private

    attr_reader :r_setor, :params
  end
end
