# frozen_string_literal: true

module GTiposAmbientesPrediais
  class DestroyService
    def self.call(g_tipo_ambiente_predial:)
      new(g_tipo_ambiente_predial:).call
    end

    def initialize(g_tipo_ambiente_predial:)
      @g_tipo_ambiente_predial = g_tipo_ambiente_predial
    end

    def call
      if g_tipo_ambiente_predial.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "G tipo ambiente predial removido com sucesso"
        )
      end

      Result.failure(
        g_tipo_ambiente_predial.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover g tipo ambiente predial"
      )
    end

    private

    attr_reader :g_tipo_ambiente_predial
  end
end
