# frozen_string_literal: true

module PTiposMovimentacoesPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Tipo de movimentacao do patrimonio")
    end
  end
end
