# frozen_string_literal: true

module UTemplates
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_template = UTemplate.new(params)

      if u_template.save
        return Result.success(
          u_template,
          HttpStatus::CREATED,
          "Template criado com sucesso"
        )
      end

      Result.failure(
        u_template.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u template"
      )
    end

    private

    attr_reader :params
  end
end
