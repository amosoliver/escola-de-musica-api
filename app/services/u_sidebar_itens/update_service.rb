# frozen_string_literal: true

module USidebarItens
  class UpdateService
    def self.call(u_sidebar_item:, params:)
      new(u_sidebar_item:, params:).call
    end

    def initialize(u_sidebar_item:, params:)
      @u_sidebar_item = u_sidebar_item
      @params = params
    end

    def call
      if u_sidebar_item.update(params)
        return Result.success(
          u_sidebar_item,
          HttpStatus::OK,
          "U sidebar item atualizado com sucesso"
        )
      end

      Result.failure(
        u_sidebar_item.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u sidebar item"
      )
    end

    private

    attr_reader :u_sidebar_item, :params
  end
end
