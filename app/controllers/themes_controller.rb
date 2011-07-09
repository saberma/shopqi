#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:theme) { shop.theme }
  expose(:settings_html) { theme.settings.transform }
  expose(:settings_json) { theme.settings.as_json.to_json }

  def settings
  end

  def update # 更新主题配置
    theme.settings.save params[:theme][:load_preset], params[:theme][:settings]
    render nothing: true
  end
end
