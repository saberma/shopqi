#encoding: utf-8
class Admin::AssetsController < Admin::AppController
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
    qqfile = QqFile.new params[:qqfile], request
    image = qqfile.body
    max_width = params['max_width']
    max_height = params['max_height']
    unless max_width.blank? or max_height.blank? # 限制宽高
      image = MiniMagick::Image.read(image)
      image.resize "#{max_width}x#{max_height}"
    end
    asset = Asset.create theme, params[:key], nil, image
    render text: asset.to_json
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
