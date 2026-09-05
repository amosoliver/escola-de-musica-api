# frozen_string_literal: true

module PStatusManutencoesPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PStatusManutencaoPatrimonio, params:, resource_name: "Status de manutencao do patrimonio")
    end
  end
end
