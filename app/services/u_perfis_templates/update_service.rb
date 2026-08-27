# frozen_string_literal: true

module UPerfisTemplates
  class UpdateService
    def self.call(u_perfil_template:, params:)
      new(u_perfil_template:, params:).call
    end

    def initialize(u_perfil_template:, params:)
      @u_perfil_template = u_perfil_template
      @params = params
    end

    def call
      if u_perfil_template.update(params)
        return Result.success(
          u_perfil_template,
          HttpStatus::OK,
          "U perfil template atualizado com sucesso"
        )
      end

      Result.failure(
        u_perfil_template.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u perfil template"
      )
    end

    private

    attr_reader :u_perfil_template, :params
  end
end
