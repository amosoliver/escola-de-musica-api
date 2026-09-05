# frozen_string_literal: true

module PTiposAquisicoesPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PTipoAquisicaoPatrimonio, params:, resource_name: "Tipo de aquisicao do patrimonio")
    end
  end
end
