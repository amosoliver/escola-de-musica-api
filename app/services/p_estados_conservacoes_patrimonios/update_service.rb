# frozen_string_literal: true

module PEstadosConservacoesPatrimonios
  class UpdateService < PatrimonioReferencialUpdateService
    def self.call(record:, params:) = new(record:, params:).call

    def initialize(record:, params:)
      super(record:, params:, resource_name: "Estado de conservacao do patrimonio")
    end
  end
end
