# frozen_string_literal: true

module USidebars
  class UpdateService
    def self.call(u_sidebar:, params:)
      new(u_sidebar:, params:).call
    end

    def initialize(u_sidebar:, params:)
      @u_sidebar = u_sidebar
      @params = params
    end

    def call
      if u_sidebar.update(params)
        return Result.success(
          u_sidebar,
          HttpStatus::OK,
          "U sidebar atualizado com sucesso"
        )
      end

      Result.failure(
        u_sidebar.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel atualizar u sidebar"
      )
    end

    private

    attr_reader :u_sidebar, :params
  end
end
