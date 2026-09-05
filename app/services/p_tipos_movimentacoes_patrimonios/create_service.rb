# frozen_string_literal: true

module PTiposMovimentacoesPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PTipoMovimentacaoPatrimonio, params:, resource_name: "Tipo de movimentacao do patrimonio")
    end
  end
end
