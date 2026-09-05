# frozen_string_literal: true

module PStatusManutencoesPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Status de manutencao do patrimonio")
    end
  end
end
