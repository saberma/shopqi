#encoding: utf-8
class ThemesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin', except: :edit

  expose(:shop) { current_user.shop }
  expose(:theme) { shop.theme }

  def current
    @assets_json = theme.list.to_json
  end

  # 获取文件内容
  def asset
    render text: theme.value(params[:tree_id], params[:key])
  end

  # 更新主题文件
  def update
    theme.save_file params[:key], params[:value]
    render nothing: true
  end

  # 版本信息
  def versions
    commit = theme.commits(params[:key]).as_json
    render json: commit.to_json(only: ['id', 'message', 'tree'])
  end

  # 弹出新窗口编辑
  def edit
  end
end
