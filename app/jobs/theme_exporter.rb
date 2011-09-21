# encoding: utf-8
module ThemeExporter

  @queue = "theme_exporter"

  def self.perform(shop_id, theme_id) # 导出tmp/theme_exporter/shopqi/qiao-mu-ling-di-057ae9ce55.tar.gz
    shop = Shop.find(shop_id)
    theme = shop.themes.find(theme_id)
    theme_exporter_path = Rails.root.join('tmp', 'theme_exporter', test_dir, shop.domains.myshopqi.subdomain)
    FileUtils.mkdir_p theme_exporter_path
    repo = Grit::Repo.new theme.public_path
    sha = repo.commits(nil, 1).first.sha[0, 10]
    file_path = File.join theme_exporter_path, "#{Pinyin.t(theme.name, '-')}-#{sha}.tar.gz"
    repo.archive_to_file('master', nil, file_path) unless File.exists?(file_path)
  end

end
