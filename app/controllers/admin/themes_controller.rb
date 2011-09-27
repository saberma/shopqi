#encoding: utf-8
require 'zip/zip'
require 'zip/zipfilesystem'
class Admin::ThemesController < Admin::AppController
  prepend_before_filter :authenticate_user!, except: [:switch]
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:themes) { shop.themes }
  expose(:theme)

  begin 'api'
    def switch
      authorization = OAuth2::Provider.access_token(nil, [], request)
      if authorization.valid?
        shop = authorization.owner
        theme = Theme.find_by_handle params[:handle]
        shop.theme.switch theme, params[:style_handle]
      end
      render nothing: true
    end
  end

  begin 'admin' # 后台管理

    def index # 主题管理
      themes = shop.themes
      published_themes = themes.select {|theme| theme.published? }
      unpublished_themes = themes.select {|theme| theme.unpublished? }
      @published_themes_json = published_themes.to_json(except: [:created_at, :updated_at])
      @unpublished_themes_json = unpublished_themes.to_json(except: [:created_at, :updated_at])
    end

    def upload # 上传主题(只检查必须的文件，解压操作转入后台运行)
      path = Rails.root.join 'tmp', 'themes', shop.id.to_s
      name = params[:qqfile]
      zip_path = File.join path, "t#{DateTime.now.to_i}-#{name}"
      name = name[0, name.rindex('.')] # 去掉文件后缀
      FileUtils.mkdir_p path
      File.open(zip_path, 'wb') {|f| f.write(request.raw_post) }
      files = []
      addition_root_dir = '' # 兼容额外的一级目录
      begin
        Zip::ZipFile::open(zip_path) do |zf|
          root_dirs = zf.dir.entries('.')
          addition_root_dir = root_dirs.first if root_dirs.size == 1 and !%w(layout templates).include?(root_dirs.first)
          addition_regexp = Regexp.new("^#{addition_root_dir}/")
          zf.each do |e|
            file_name = addition_root_dir.blank? ?  e.name : e.name.sub(addition_regexp, '')
            files << file_name unless file_name.blank? or file_name.end_with?('/')
          end
        end
      rescue
        render json: {error_type: true} and return # 上传非zip文件，提示错误直接返回
      end

      missing = nil
      ShopTheme::REQUIRED_FILES.each do |required_file|
        next if files.include?(required_file)
        missing = required_file
        break
      end

      unless missing.blank?
        render json: {missing: missing} and return
      end

      shop_theme = shop.themes.create name: name, role: 'wait' # 等待解压主题文件
      Resque.enqueue(ThemeExtracter, shop.id, shop_theme.id, zip_path, addition_root_dir)
      render json: {id: shop_theme.id, name: shop_theme.name}
    end

    def update # 发布主题
      shop.theme.unpublish!
      theme.save
      render nothing: true
    end

    def background_queue_status # 检查主题是否解压完成
      if theme.role == 'wait'
        render json: nil
      else
        render json: theme.to_json(except: [:created_at, :updated_at])
      end
    end

    def duplicate # 复制主题
      duplicate_theme = theme.duplicate
      render json: duplicate_theme.to_json(except: [:created_at, :updated_at])
    end

    def destroy # 删除
      theme.destroy
      render json: theme.to_json(except: [:created_at, :updated_at])
    end

    def export # 导出(后台任务型)
      user = shop.users.where(admin: true).first
      Resque.enqueue(ThemeExporter, shop.id, params[:id].to_i)
      render text: "#{user.name} &lt;#{user.email}>"
    end

  end

end
