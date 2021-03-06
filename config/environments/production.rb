Myflix::Application.configure do

  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  #config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    user_name: ENV["GMAIL_USER_NAME"],
    password: ENV["GMAIL_USER_PASSWORD"],
    authentication: :plain,
    enable_starttls_auto: true
  }

  config.assets.precompile += %w( payment.js )

  config.action_mailer.default_url_options = { host: 'gentle-beyond-6652.herokuapp.com'}

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
