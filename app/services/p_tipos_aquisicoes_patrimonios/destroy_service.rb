# frozen_string_literal: true

module PTiposAquisicoesPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Tipo de aquisicao do patrimonio")
    end
  end
end
