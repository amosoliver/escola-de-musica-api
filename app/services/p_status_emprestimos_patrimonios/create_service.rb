# frozen_string_literal: true

module PStatusEmprestimosPatrimonios
  class CreateService < PatrimonioReferencialCreateService
    def self.call(params:) = new(params:).call

    def initialize(params:)
      super(model: PStatusEmprestimoPatrimonio, params:, resource_name: "Status de emprestimo do patrimonio")
    end
  end
end
