# frozen_string_literal: true

module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    attr_reader :current_user, :current_token_payload
  end

  private

  def authenticate_request!
    payload = Auth::JsonWebToken.decode(bearer_token)

    return unauthorized!("Token invalido ou expirado") if payload.nil? || payload["typ"] != "access"

    user = User.find_by(id: payload["sub"])
    return unauthorized!("Usuario nao encontrado") unless user
    return unauthorized!(user.motivo_bloqueio.presence || "Usuario bloqueado") if user.bloqueado?

    @current_token_payload = payload
    @current_user = user
  end

  def bearer_token
    header = request.headers["Authorization"]
    return nil if header.blank?

    header.split(" ").last
  end

  def unauthorized!(message)
    render json: { success: false, message:, errors: [ message ], timestamp: Time.current.iso8601 }, status: :unauthorized
  end
end
