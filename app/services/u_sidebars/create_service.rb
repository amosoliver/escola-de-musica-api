# frozen_string_literal: true

module USidebars
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      u_sidebar = USidebar.new(params)

      if u_sidebar.save
        return Result.success(
          u_sidebar,
          HttpStatus::CREATED,
          "Sidebar criada com sucesso"
        )
      end

      Result.failure(
        u_sidebar.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar u sidebar"
      )
    end

    private

    attr_reader :params
  end
end
