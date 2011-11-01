# encoding: utf-8
module ThemeExtracter

  @queue = "theme_extracter"

  def self.perform(shop_id, theme_id, zip_path) # 用户上传主题文件后，转入后台解压
    shop = Shop.find(shop_id)
    shop_theme = shop.themes.find(theme_id)
    path = shop_theme.path
    shop_theme.create_repo do
      begin
        Zip::ZipFile::open(zip_path) do |zf|
          zf.each do |e|
            file_name = e.name
            match = ShopTheme::ZIP_DIRECTORIES.match(file_name) # 去掉多余的顶层目录
            next unless match
            file_name = file_name.sub ShopTheme::ZIP_DIRECTORIES, match[1]
            fpath = File.join(path, file_name)
            FileUtils.mkdir_p File.dirname(fpath)
            zf.extract e, fpath
          end
        end
      rescue => e
        puts "解压文件发生错误:#{e}"
        raise e
      end
    end
    shop_theme.unpublish! # 由wait等待解压状态改为未发布状态
  end

end
