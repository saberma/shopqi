if development? # quiet assets
  Rails::Rack::Logger.class_eval do # https://github.com/rails/rails/issues/4569
    def call_with_quiet_assets(env)
      previous_level = Rails.logger.level
      Rails.logger.level = Logger::ERROR if env['PATH_INFO'].index("/assets/") == 0 
      call_without_quiet_assets(env).tap do
        Rails.logger.level = previous_level
      end 
    end 
    alias_method_chain :call, :quiet_assets 
  end 
end
