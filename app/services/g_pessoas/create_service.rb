# frozen_string_literal: true

module GPessoas
  class CreateService
    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
    end

    def call
      g_pessoa = GPessoa.new(params)

      if g_pessoa.save
        return Result.success(
          g_pessoa,
          HttpStatus::CREATED,
          "G pessoa criado com sucesso"
        )
      end

      Result.failure(
        g_pessoa.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar g pessoa"
      )
    end

    private

    attr_reader :params
  end
end
