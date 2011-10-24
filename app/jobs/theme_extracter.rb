# encoding: utf-8
module ThemeExtracter

  @queue = "theme_extracter"

  def self.perform(shop_id, theme_id, zip_path, addition_root_dir) # 用户上传主题文件后，转入后台解压
    shop = Shop.find(shop_id)
    shop_theme = shop.themes.find(theme_id)
    path = shop_theme.path
    repo = Grit::Repo.init path # 初始化为git repo
    begin
      Zip::ZipFile::open(zip_path) do |zf|
        addition_regexp = Regexp.new("^#{addition_root_dir}/")
        zf.each do |e|
          file_name = addition_root_dir.blank? ?  e.name : e.name.sub(addition_regexp, '')
          fpath = File.join(path, file_name)
          FileUtils.mkdir_p File.dirname(fpath)
          zf.extract e, fpath
        end
      end
    rescue => e
      puts "解压文件发生错误:#{e}"
      raise e
    end
    shop_theme.commit repo, '1' # TODO: 重构进主题类
    shop_theme.load_preset = shop_theme.config_settings['current'] # 初始化主题设置
    shop_theme.config_settings['presets'][shop_theme.load_preset].each_pair do |name, value|
      shop_theme.settings.create name: name, value: value
    end
    FileUtils.mkdir_p shop_theme.public_path # 主题文件只有附件对外公开，其他文件不能被外部访问
    FileUtils.ln_s File.join(path, 'assets'), File.join(shop_theme.public_path, 'assets')
    shop_theme.unpublish!
  end

end
