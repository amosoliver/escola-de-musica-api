# frozen_string_literal: true

module RTiposVinculos
  class UpdateService
    def self.call(r_tipo_vinculo:, params:)
      new(r_tipo_vinculo:, params:).call
    end

    def initialize(r_tipo_vinculo:, params:)
      @r_tipo_vinculo = r_tipo_vinculo
      @params = params
    end

    def call
      return Result.success(r_tipo_vinculo, HttpStatus::OK, "Tipo de vinculo atualizado com sucesso") if r_tipo_vinculo.update(params)

      Result.failure(r_tipo_vinculo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar r tipo vinculo")
    end

    private

    attr_reader :r_tipo_vinculo, :params
  end
end
