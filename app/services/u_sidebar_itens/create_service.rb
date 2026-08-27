# frozen_string_literal: true

module USidebarItens
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_sidebar_item = USidebarItem.new(params)

      if u_sidebar_item.save
        return Result.success(
          u_sidebar_item,
          HttpStatus::CREATED,
          "U sidebar item criado com sucesso"
        )
      end

      Result.failure(
        u_sidebar_item.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u sidebar item"
      )
    end

    private

    attr_reader :params
  end
end
