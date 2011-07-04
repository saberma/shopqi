#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:theme) { shop.theme }

  def current
    @assets_json = theme.list.to_json
  end

  # 获取文件内容
  def asset
    render text: theme.value(params[:id])
  end

  # 更新主题文件
  def update
    theme.save_file params[:key], params[:value]
    render nothing: true
  end
end
