Shopqi::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[ShopQi] ",
  :sender_address => %{"ShopQi Notifier"},
  :exception_recipients => %W{#{SecretSetting.author.email}}
