# frozen_string_literal: true

module Auth
  class RefreshService
    def self.call(refresh_token:)
      new(refresh_token:).call
    end

    def initialize(refresh_token:)
      @refresh_token = refresh_token
    end

    def call
      payload = Auth::JsonWebToken.decode(refresh_token)
      return token_invalido unless payload && payload["typ"] == "refresh"

      user = User.find_by(id: payload["sub"])
      return token_invalido unless user && user.refresh_token.present? && user.refresh_token == payload["jti"]
      return usuario_bloqueado(user) if user.bloqueado?

      Result.success(Auth::TokenIssuer.emitir(user), HttpStatus::OK, "Token renovado com sucesso")
    end

    private

    attr_reader :refresh_token

    def token_invalido
      Result.failure("Refresh token invalido ou expirado", HttpStatus::UNAUTHORIZED)
    end

    def usuario_bloqueado(user)
      Result.failure(user.motivo_bloqueio.presence || "Usuario bloqueado", HttpStatus::FORBIDDEN)
    end
  end
end
