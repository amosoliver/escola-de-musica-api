# frozen_string_literal: true

module PTiposBaixasPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Tipo de baixa do patrimonio")
    end
  end
end
