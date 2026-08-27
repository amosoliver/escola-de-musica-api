# frozen_string_literal: true

module UTemplates
  class UpdateService
    def self.call(u_template:, params:)
      new(u_template:, params:).call
    end

    def initialize(u_template:, params:)
      @u_template = u_template
      @params = params
    end

    def call
      if u_template.update(params)
        return Result.success(
          u_template,
          HttpStatus::OK,
          "U template atualizado com sucesso"
        )
      end

      Result.failure(
        u_template.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u template"
      )
    end

    private

    attr_reader :u_template, :params
  end
end
