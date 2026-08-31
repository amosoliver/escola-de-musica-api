# frozen_string_literal: true

module Auth
  class LoginService
    MAX_TENTATIVAS = 5

    def self.call(login:, password:)
      new(login:, password:).call
    end

    def initialize(login:, password:)
      @login = login
      @password = password
    end

    def call
      return Result.failure("Informe login e senha", HttpStatus::UNPROCESSABLE_ENTITY) if login.blank? || password.blank?

      user = User.find_for_database_authentication(login:)
      return credenciais_invalidas unless user
      return usuario_bloqueado(user) if user.bloqueado?

      unless user.valid_password?(password)
        registrar_tentativa_invalida(user)
        return credenciais_invalidas
      end

      registrar_login_bem_sucedido(user)
      Result.success(Auth::TokenIssuer.emitir(user), HttpStatus::OK, "Login realizado com sucesso")
    end

    private

    attr_reader :login, :password

    def credenciais_invalidas
      Result.failure("CPF/e-mail ou senha invalidos", HttpStatus::UNAUTHORIZED)
    end

    def usuario_bloqueado(user)
      Result.failure(user.motivo_bloqueio.presence || "Usuario bloqueado", HttpStatus::FORBIDDEN)
    end

    def registrar_tentativa_invalida(user)
      tentativas = user.tentativas_acesso.to_i + 1
      atributos = { tentativas_acesso: tentativas }

      if tentativas >= MAX_TENTATIVAS
        atributos.merge!(
          bloqueado: true,
          data_bloqueio: Time.current,
          motivo_bloqueio: "Bloqueado apos #{MAX_TENTATIVAS} tentativas de login invalidas"
        )
      end

      user.update_columns(atributos)
    end

    def registrar_login_bem_sucedido(user)
      user.update_columns(tentativas_acesso: 0, data_ultimo_acesso: Time.current)
    end
  end
end
