Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    cors_origins = ENV["URL_CORS"].presence || "*"
    origins cors_origins == "*" ? "*" : cors_origins.split(",").map(&:strip)

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end
