# frozen_string_literal: true

module RTiposVinculos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      r_tipo_vinculo = RTipoVinculo.new(params)
      return Result.success(r_tipo_vinculo, HttpStatus::CREATED, "Tipo de vinculo criado com sucesso") if r_tipo_vinculo.save

      Result.failure(r_tipo_vinculo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar r tipo vinculo")
    end

    private

    attr_reader :params
  end
end
