# frozen_string_literal: true

module PSituacoesPatrimonios
  class UpdateService < PatrimonioReferencialUpdateService
    def self.call(record:, params:) = new(record:, params:).call

    def initialize(record:, params:)
      super(record:, params:, resource_name: "Situacao de patrimonio")
    end
  end
end
