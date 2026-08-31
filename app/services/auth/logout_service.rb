# frozen_string_literal: true

module Auth
  # Invalida o refresh_token corrente do usuario (logout). Idempotente: um
  # refresh_token ja invalido/expirado tambem retorna sucesso.
  class LogoutService
    def self.call(refresh_token:)
      new(refresh_token:).call
    end

    def initialize(refresh_token:)
      @refresh_token = refresh_token
    end

    def call
      payload = Auth::JsonWebToken.decode(refresh_token)
      user = payload && User.find_by(id: payload["sub"])
      user&.update_columns(refresh_token: nil)

      Result.success(nil, HttpStatus::NO_CONTENT, "Logout realizado com sucesso")
    end

    private

    attr_reader :refresh_token
  end
end
