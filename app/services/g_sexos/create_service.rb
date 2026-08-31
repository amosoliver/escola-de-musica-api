# frozen_string_literal: true

module GSexos
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_sexo = GSexo.new(params)

      if g_sexo.save
        return Result.success(
          g_sexo,
          HttpStatus::CREATED,
          "Sexo criado com sucesso"
        )
      end

      Result.failure(
        g_sexo.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g sexo"
      )
    end

    private

    attr_reader :params
  end
end
