# frozen_string_literal: true

module UPerfisTemplates
  class DestroyService
    def self.call(u_perfil_template:)
      new(u_perfil_template:).call
    end

    def initialize(u_perfil_template:)
      @u_perfil_template = u_perfil_template
    end

    def call
      if u_perfil_template.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Perfil template removido com sucesso"
        )
      end

      Result.failure(
        u_perfil_template.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u perfil template"
      )
    end

    private

    attr_reader :u_perfil_template
  end
end
