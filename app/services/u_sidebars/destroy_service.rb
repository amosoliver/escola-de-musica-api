# frozen_string_literal: true

module USidebars
  class DestroyService
    def self.call(u_sidebar:)
      new(u_sidebar:).call
    end

    def initialize(u_sidebar:)
      @u_sidebar = u_sidebar
    end

    def call
      if u_sidebar.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "Sidebar removida com sucesso"
        )
      end

      Result.failure(
        u_sidebar.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u sidebar"
      )
    end

    private

    attr_reader :u_sidebar
  end
end
