# frozen_string_literal: true

module PTiposBaixasPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PTipoBaixaPatrimonio, params:, resource_name: "Tipo de baixa do patrimonio")
    end
  end
end
