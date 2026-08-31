# frozen_string_literal: true

module RTiposVinculos
  class DestroyService
    def self.call(r_tipo_vinculo:)
      new(r_tipo_vinculo:).call
    end

    def initialize(r_tipo_vinculo:)
      @r_tipo_vinculo = r_tipo_vinculo
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Tipo de vinculo removido com sucesso") if r_tipo_vinculo.destroy

      Result.failure(r_tipo_vinculo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover r tipo vinculo")
    end

    private

    attr_reader :r_tipo_vinculo
  end
end
