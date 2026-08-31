# frozen_string_literal: true

module UPerfisTemplates
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_perfil_template = UPerfilTemplate.new(params)

      if u_perfil_template.save
        return Result.success(
          u_perfil_template,
          HttpStatus::CREATED,
          "Perfil template criado com sucesso"
        )
      end

      Result.failure(
        u_perfil_template.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u perfil template"
      )
    end

    private

    attr_reader :params
  end
end
