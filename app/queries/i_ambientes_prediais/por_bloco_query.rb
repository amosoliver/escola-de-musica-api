# frozen_string_literal: true

module IAmbientesPrediais
  class PorBlocoQuery
    def self.call(i_bloco_id:)
      new(i_bloco_id:).call
    end

    def initialize(i_bloco_id:)
      @i_bloco_id = i_bloco_id
    end

    def call
      IAmbientePredial.where(i_bloco_id:).order(:id)
    end

    private

    attr_reader :i_bloco_id
  end
end
