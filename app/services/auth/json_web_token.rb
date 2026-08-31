# frozen_string_literal: true

module Auth
  class JsonWebToken
    ALGORITHM = "HS256"

    class << self
      def encode(payload)
        JWT.encode(payload, secret, ALGORITHM)
      end

      def decode(token)
        return nil if token.blank?

        decoded = JWT.decode(token, secret, true, algorithm: ALGORITHM).first
        ActiveSupport::HashWithIndifferentAccess.new(decoded)
      rescue JWT::DecodeError
        nil
      end

      private

      def secret
        Rails.application.secret_key_base
      end
    end
  end
end
