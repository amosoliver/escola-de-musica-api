# frozen_string_literal: true

module PStatusEmprestimosPatrimonios
  class DestroyService < PatrimonioReferencialDestroyService
    def self.call(record:) = new(record:).call

    def initialize(record:)
      super(record:, resource_name: "Status de emprestimo do patrimonio")
    end
  end
end
