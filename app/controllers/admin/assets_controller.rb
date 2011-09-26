#encoding: utf-8
class AssetsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin', except: :edit

  expose(:shop) { current_user.shop }
  expose(:themes) { shop.themes }
  expose(:theme)

  def index
    @assets_json = Asset.all(theme).to_json
  end

  def show # 获取文件内容(id为tree_id)
    render text: Asset.value(theme, params[:id], params[:key])
  end

  def create # 新增文件
    Asset.create theme, params[:key], params[:source_key]
    render nothing: true
  end

  def upload # 上传asset附件
    asset = Asset.create theme, params[:key], nil, request.body.read
    render json: asset.to_json
  end

  def update # 更新主题文件
    Asset.update theme, params[:key], params[:value]
    render nothing: true
  end

  def rename # 重命名
    Asset.rename theme, params[:key], params[:new_key]
    render nothing: true
  end

  def destroy # 删除主题文件
    Asset.destroy theme, params[:key]
    render nothing: true
  end

  def versions # 版本信息
    commit = Asset.commits(theme, params[:key]).as_json
    render json: commit.to_json(only: ['id', 'message', 'tree'])
  end

  def edit # 弹出新窗口编辑
  end
end
