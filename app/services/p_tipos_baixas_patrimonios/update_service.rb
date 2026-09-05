# frozen_string_literal: true

module PTiposBaixasPatrimonios
  class UpdateService < PatrimonioReferencialUpdateService
    def self.call(record:, params:) = new(record:, params:).call

    def initialize(record:, params:)
      super(record:, params:, resource_name: "Tipo de baixa do patrimonio")
    end
  end
end
