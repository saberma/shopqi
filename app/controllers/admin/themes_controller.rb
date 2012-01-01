#encoding: utf-8
require 'zip/zip'
require 'zip/zipfilesystem'
class Admin::ThemesController < Admin::AppController
  prepend_before_filter :authenticate_user!, except: [:install]
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:themes) { shop.themes }
  expose(:theme)

  begin 'api'

    def install
      authorization = OAuth2::Provider.access_token(nil, [], request)
      shop = authorization.owner
      if authorization.valid?
        if shop.themes.exceed? # 超出主题数则不更新
          render json: {error: '商店的主题总数不能超过8个，请删除不再使用的主题!'} and return
        else
          theme = Theme.where(handle: params[:handle], style_handle: params[:style_handle]).first
          shop.themes.install theme
        end
      else
        render json: {error: '认证错误!'} and return
      end
      render json: {} # 安装成功
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
      if shop.themes.exceed?
        request.raw_post # fixed: 需要先接收数据，否则浏览器直接显示上传被cancle，无法获取返回的json数据
        render text: {exceed: true}.to_json and return
      end
      path = Rails.root.join 'tmp', 'themes', shop.id.to_s
      qqfile = QqFile.new params[:qqfile], request
      name = qqfile.name
      zip_path = File.join path, "t#{DateTime.now.to_i}-#{name}"
      name = name[0, name.rindex('.')] # 去掉文件后缀
      name = name[0, 32] # 最多32位
      name = Asset.safe(name) # 过滤文件名
      FileUtils.mkdir_p path
      File.open(zip_path, 'wb') {|f| f.write(qqfile.body) }
      files = []
      begin
        Zip::ZipFile::open(zip_path) do |zf|
          zf.each do |e|
            file_name = e.name
            match = ShopTheme::ZIP_DIRECTORIES.match(file_name) # 去掉多余的顶层目录
            next unless match
            file_name = file_name.sub ShopTheme::ZIP_DIRECTORIES, match[1]
            files << file_name unless file_name.blank? or file_name.end_with?('/')
          end
        end
      rescue => e
        puts e
        render text: {error_type: true}.to_json and return # 上传非zip文件，提示错误直接返回
      end

      missing = nil
      ShopTheme::REQUIRED_FILES.each do |required_file|
        next if files.include?(required_file)
        missing = required_file
        break
      end

      unless missing.blank?
        render text: {missing: missing}.to_json and return
      end

      shop_theme = shop.themes.create name: name, role: 'wait' # 等待解压主题文件
      Resque.enqueue(ThemeExtracter, shop.id, shop_theme.id, zip_path)
      render text: {id: shop_theme.id, name: shop_theme.name}.to_json
    end

    def current # 当前主题的模板编辑器
      theme_id = session[:preview_theme_id]
      theme = theme_id.blank? ? shop.theme : shop.themes.find(theme_id)
      redirect_to theme_assets_path(theme)
    end

    def settings # 当前主题的外观设置
      theme_id = session[:preview_theme_id]
      theme = theme_id.blank? ? shop.theme : shop.themes.find(theme_id)
      redirect_to settings_theme_path(theme)
    end

    def update # 发布主题
      shop.theme.unpublish! if shop.theme
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
      if shop.themes.exceed?
        render json: {exceed: true}
      else
        duplicate_theme = theme.duplicate
        render json: duplicate_theme.to_json(except: [:created_at, :updated_at])
      end
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
