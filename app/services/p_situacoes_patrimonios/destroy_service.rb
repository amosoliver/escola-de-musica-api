# frozen_string_literal: true

module PSituacoesPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Situacao de patrimonio")
    end
  end
end
