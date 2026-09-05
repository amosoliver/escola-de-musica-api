# frozen_string_literal: true

module PTiposArquivosPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Tipo de arquivo do patrimonio")
    end
  end
end
