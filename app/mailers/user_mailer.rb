# frozen_string_literal: true

class UserMailer < Devise::Mailer
  default from: ENV.fetch("SMTP_USERNAME", ENV.fetch("DEVISE_MAILER_SENDER", "no-reply@escolademusica.local"))
  layout "mailer"

  def reset_password_instructions(record, token, opts = {})
    @usuario = record
    @token = token
    @app_nome = "Escola de Musica"
    @token_validade = Devise.reset_password_within
    @token_validade_label = token_validade_label(@token_validade)
    @recuperar_senha_url = edit_user_password_url(reset_password_token: token)
    @primeiro_acesso = @usuario.primeiro_acesso?
    opts[:subject] ||= if @primeiro_acesso
      "Defina sua senha de acesso"
    else
      I18n.t("devise.mailer.reset_password_instructions.subject", default: "Redefinicao de senha")
    end

    devise_mail(record, :reset_password_instructions, opts)
  end

  private

  def token_validade_label(duration)
    hours = (duration.to_i / 1.hour).round
    return "#{hours} hora".pluralize(hours) if hours.positive? && (duration.to_i % 1.hour).zero?

    minutes = (duration.to_i / 1.minute).round
    "#{minutes} minuto".pluralize(minutes)
  end
end
