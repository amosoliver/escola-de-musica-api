# frozen_string_literal: true

module GAndares
  class PorPredioQuery
    def self.call(i_predio_id:)
      new(i_predio_id:).call
    end

    def initialize(i_predio_id:)
      @i_predio_id = i_predio_id
    end

    def call
      GAndar.joins(:i_blocos)
            .where(i_blocos: { i_predio_id: })
            .distinct
            .order(:ordem, :id)
    end

    private

    attr_reader :i_predio_id
  end
end
