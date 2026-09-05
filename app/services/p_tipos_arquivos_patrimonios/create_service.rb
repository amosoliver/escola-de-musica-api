# frozen_string_literal: true

module PTiposArquivosPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PTipoArquivoPatrimonio, params:, resource_name: "Tipo de arquivo do patrimonio")
    end
  end
end
