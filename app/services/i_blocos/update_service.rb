# frozen_string_literal: true

module IBlocos
  class UpdateService
    def self.call(i_bloco:, params:)
      new(i_bloco:, params:).call
    end

    def initialize(i_bloco:, params:)
      @i_bloco = i_bloco
      @params = params
    end

    def call
      if i_bloco.update(params)
        return Result.success(
          i_bloco,
          HttpStatus::OK,
          "I bloco atualizado com sucesso"
        )
      end

      Result.failure(
        i_bloco.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar i bloco"
      )
    end

    private

    attr_reader :i_bloco, :params
  end
end
