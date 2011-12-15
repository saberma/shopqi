Shopqi::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  #config.action_dispatch.x_sendfile_header = "X-Sendfile"

  config.middleware.use Rack::SSL, exclude: lambda {|env| # 测试用例:spec/controllers/shop/shops_controller_spec.rb
    return true if env['HTTP_USER_AGENT'] =~ /(bot|crawl|spider)/i # 搜索引擎不使用https协议
    host = env['SERVER_NAME']
    path = env['PATH_INFO']
    return false if host == Setting.host # shopqi.com
    if host.end_with?(Setting.store_host) # 二级域名(www.shopqi.com等使用https，example.shopqi.com不使用，除非访问/admin)
      not_admin_or_user = !(path.start_with?('/admin') or path.start_with?('/user')) # 不是后台管理或者登录页面
      return (not_admin_or_user and !(Regexp.new("(www|themes|wiki|app|checkout)#{Setting.store_host}") =~ host))
    end
    true
  }

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # Compress JavaScripts and CSS
  config.assets.compress = true
  config.assets.js_compressor  = :uglifier
  # Generate digests for assets URLs
  config.assets.digest = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # 指定域名，否则访问themes子域名后,再访问wiki子域名时附件需要重新下载
  config.action_controller.asset_host = Proc.new { |source|
    "//cdn.shopqi.com"
  }

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w(
    shopqi_application.js shopqi_wiki_application.js admin_application.js checkout_application.js active_admin.js
    layout_application.css layout_admin.css layout_admin_print.css layout_shopqi.css
    shopqi_ie-signup.css layout_shopqi_theme.css active_admin.css layout_shopqi_wiki.css
    layout_checkout.css
    ie6.css ie-admin.css ie7.css ie-checkout.css ie.css ie-themes.css ie7-themes.css
  )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :sendmail

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
