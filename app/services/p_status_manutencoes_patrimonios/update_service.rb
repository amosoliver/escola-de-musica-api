# frozen_string_literal: true

module PStatusManutencoesPatrimonios
  class UpdateService < PatrimonioReferencialUpdateService
    def self.call(record:, params:) = new(record:, params:).call

    def initialize(record:, params:)
      super(record:, params:, resource_name: "Status de manutencao do patrimonio")
    end
  end
end
