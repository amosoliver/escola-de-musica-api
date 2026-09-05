# frozen_string_literal: true

module PTiposAquisicoesPatrimonios
  class UpdateService < PatrimonioReferencialUpdateService
    def self.call(record:, params:) = new(record:, params:).call

    def initialize(record:, params:)
      super(record:, params:, resource_name: "Tipo de aquisicao do patrimonio")
    end
  end
end
