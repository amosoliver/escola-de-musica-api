require_relative "boot"

require "rails/all"
require "dotenv/load"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EscolaDeMusicaApi
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])

    config.exceptions_app = routes
    config.time_zone = "La Paz"
    config.i18n.default_locale = :"pt-BR"
    config.api_only = true

    config.generators do |g|
      g.templates.unshift File.expand_path("../lib/templates", __dir__)
    end

    config.autoload_paths << Rails.root.join("lib")
    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: "gmail.com",
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
end
