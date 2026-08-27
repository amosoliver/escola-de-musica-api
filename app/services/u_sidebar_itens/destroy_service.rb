# frozen_string_literal: true

module USidebarItens
  class DestroyService
    def self.call(u_sidebar_item:)
      new(u_sidebar_item:).call
    end

    def initialize(u_sidebar_item:)
      @u_sidebar_item = u_sidebar_item
    end

    def call
      if u_sidebar_item.destroy
        return Result.success(
          nil,
          HttpStatus::NO_CONTENT,
          "U sidebar item removido com sucesso"
        )
      end

      Result.failure(
        u_sidebar_item.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel remover u sidebar item"
      )
    end

    private

    attr_reader :u_sidebar_item
  end
end
