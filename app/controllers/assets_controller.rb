#encoding: utf-8
class AssetsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin', except: :edit

  expose(:shop) { current_user.shop }
  expose(:theme) { shop.theme }

  def index
    @assets_json = Asset.all(theme).to_json
  end

  # 获取文件内容
  def show
    render text: Asset.value(theme, params[:id], params[:key])
  end

  # 更新主题文件
  def update
    Asset.update theme, params[:key], params[:value]
    render nothing: true
  end

  # 重命名
  def rename
    Asset.rename theme, params[:key], params[:new_key]
    render nothing: true
  end

  # 删除主题文件
  def destroy
    Asset.destroy theme, params[:key]
    render nothing: true
  end

  # 版本信息
  def versions
    commit = Asset.commits(theme, params[:key]).as_json
    render json: commit.to_json(only: ['id', 'message', 'tree'])
  end

  # 弹出新窗口编辑
  def edit
  end
end
