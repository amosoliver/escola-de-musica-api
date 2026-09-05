# frozen_string_literal: true

module PTiposManutencoesPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PTipoManutencaoPatrimonio, params:, resource_name: "Tipo de manutencao do patrimonio")
    end
  end
end
