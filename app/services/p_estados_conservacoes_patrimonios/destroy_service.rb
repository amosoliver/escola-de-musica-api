# frozen_string_literal: true

module PEstadosConservacoesPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Estado de conservacao do patrimonio")
    end
  end
end
