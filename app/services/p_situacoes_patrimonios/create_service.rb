# frozen_string_literal: true

module PSituacoesPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PSituacaoPatrimonio, params:, resource_name: "Situacao de patrimonio")
    end
  end
end
