# frozen_string_literal: true

module Auth
  # Emite o par access_token/refresh_token de um usuario. O refresh_token e' um
  # JWT de vida longa cujo "jti" fica gravado em users.refresh_token; emitir um
  # novo par sempre sobrescreve esse jti, o que invalida (rotaciona) o refresh
  # token anterior automaticamente.
  class TokenIssuer
    ACCESS_TOKEN_TTL = 30.minutes
    REFRESH_TOKEN_TTL = 30.days

    def self.emitir(user)
      new(user).emitir
    end

    def initialize(user)
      @user = user
    end

    def emitir
      refresh_jti = SecureRandom.uuid
      user.update_columns(refresh_token: refresh_jti)

      {
        access_token: build_access_token,
        refresh_token: build_refresh_token(refresh_jti),
        token_type: "Bearer",
        expires_in: ACCESS_TOKEN_TTL.to_i
      }
    end

    private

    attr_reader :user

    def build_access_token
      Auth::JsonWebToken.encode(
        sub: user.id,
        jti: SecureRandom.uuid,
        typ: "access",
        cpf: user.cpf,
        nome: user.g_pessoa&.nome,
        perfis: perfis_payload,
        iat: Time.current.to_i,
        exp: ACCESS_TOKEN_TTL.from_now.to_i
      )
    end

    def build_refresh_token(jti)
      Auth::JsonWebToken.encode(
        sub: user.id,
        jti:,
        typ: "refresh",
        iat: Time.current.to_i,
        exp: REFRESH_TOKEN_TTL.from_now.to_i
      )
    end

    def perfis_payload
      user.users_perfis.where(ativo: true).includes(:u_perfil).map do |vinculo|
        {
          id: vinculo.u_perfil_id,
          codigo: vinculo.u_perfil.codigo,
          descricao: vinculo.u_perfil.descricao,
          unidade_gestora_id: vinculo.g_unidade_gestora_id
        }
      end
    end
  end
end
