# frozen_string_literal: true

module PEstadosConservacoesPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PEstadoConservacaoPatrimonio, params:, resource_name: "Estado de conservacao do patrimonio")
    end
  end
end
