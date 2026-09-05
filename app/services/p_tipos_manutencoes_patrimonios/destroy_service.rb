# frozen_string_literal: true

module PTiposManutencoesPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Tipo de manutencao do patrimonio")
    end
  end
end
