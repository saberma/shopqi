#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:theme) { shop.theme }

  def settings
  end

  def update # 更新主题配置
    render nothing: true
  end
end
