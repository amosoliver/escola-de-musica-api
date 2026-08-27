# frozen_string_literal: true

module UTemplates
  class DestroyService
    def self.call(u_template:)
      new(u_template:).call
    end

    def initialize(u_template:)
      @u_template = u_template
    end

    def call
      if u_template.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "U template removido com sucesso"
        )
      end

      Result.failure(
        u_template.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u template"
      )
    end

    private

    attr_reader :u_template
  end
end
