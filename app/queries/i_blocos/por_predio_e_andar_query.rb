# frozen_string_literal: true

module IBlocos
  class PorPredioEAndarQuery
    def self.call(i_predio_id:, g_andar_id:)
      new(i_predio_id:, g_andar_id:).call
    end

    def initialize(i_predio_id:, g_andar_id:)
      @i_predio_id = i_predio_id
      @g_andar_id = g_andar_id
    end

    def call
      IBloco.where(i_predio_id:, g_andar_id:).order(:id)
    end

    private

    attr_reader :i_predio_id, :g_andar_id
  end
end
