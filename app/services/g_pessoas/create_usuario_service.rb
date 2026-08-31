# frozen_string_literal: true

module GPessoas
  class CreateUsuarioService
    def self.call(g_pessoa:, params:)
      new(g_pessoa:, params:).call
    end

    def initialize(g_pessoa:, params:)
      @g_pessoa = g_pessoa
      @params = params
    end

    def call
      return Result.success(nil, HttpStatus::OK) unless criar_usuario?
      return failure_without_record("Informe o perfil do usuario") if acesso_params[:u_perfil_id].blank?
      return failure_without_record("Informe a unidade gestora do usuario") if acesso_params[:g_unidade_gestora_id].blank?

      user = g_pessoa.user
      return ensure_access_for_existing_user(user) if user.present?

      return failure_without_record("Informe o e-mail do usuario para envio das instrucoes de acesso") if usuario_email.blank?

      user = build_user
      return failure(user) unless user.save

      user_perfil = build_user_perfil(user)
      return failure(user_perfil) unless user_perfil.save

      enviar_instrucoes_primeiro_acesso!(user)

      Result.success(user, HttpStatus::CREATED, "Usuario criado com sucesso")
    end

    private

    attr_reader :g_pessoa, :params

    def criar_usuario?
      acesso_params.values.any?(&:present?)
    end

    def build_user
      User.new(
        g_pessoa:,
        cpf: g_pessoa.cpf,
        email: usuario_email,
        password: senha_inicial,
        password_confirmation: senha_inicial,
        primeiro_acesso: true
      )
    end

    def build_user_perfil(user)
      UserPerfil.new(user_perfil_attributes(user))
    end

    def usuario_email
      acesso_params[:email].presence || g_pessoa.email
    end

    def senha_inicial
      @senha_inicial ||= SecureRandom.hex(20)
    end

    def enviar_instrucoes_primeiro_acesso!(user)
      User.send_reset_password_instructions(login: usuario_email)
    rescue StandardError => e
      Rails.logger.error("Falha ao enviar e-mail de definicao de senha para user##{user.id}: #{e.message}")
    end

    def ensure_access_for_existing_user(user)
      if usuario_email.present? && user.email != usuario_email
        user.email = usuario_email
        return failure(user) unless user.save
      end

      user_perfil = UserPerfil.with_deleted.find_or_initialize_by(
        user:,
        u_perfil_id: acesso_params[:u_perfil_id],
        g_unidade_gestora_id: acesso_params[:g_unidade_gestora_id]
      )
      user_perfil.assign_attributes(ativo: acesso_params.fetch(:ativo, true), deleted_at: nil)
      return failure(user_perfil) unless user_perfil.save

      Result.success(user, HttpStatus::OK, "Usuario vinculado com sucesso")
    end

    def user_perfil_attributes(user)
      {
        user:,
        u_perfil_id: acesso_params[:u_perfil_id],
        g_unidade_gestora_id: acesso_params[:g_unidade_gestora_id],
        ativo: acesso_params.fetch(:ativo, true)
      }
    end

    def acesso_params
      @acesso_params ||= params.slice(
        :email,
        :u_perfil_id,
        :g_unidade_gestora_id,
        :ativo
      )
    end

    def failure(record)
      Result.failure(
        record.errors.full_messages,
        HttpStatus::UNPROCESSABLE_ENTITY,
        "Nao foi possivel criar usuario para a pessoa"
      )
    end

    def failure_without_record(message)
      Result.failure(message, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar usuario para a pessoa")
    end
  end
end
