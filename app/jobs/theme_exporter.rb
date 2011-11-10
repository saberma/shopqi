# encoding: utf-8
module ThemeExporter

  @queue = "theme_exporter"

  def self.perform(shop_id, theme_id) # 导出tmp/theme_exporter/shopqi/qiao-mu-ling-di-057ae9ce55.tar.gz
    shop = Shop.find(shop_id)
    theme = shop.themes.find(theme_id)
    repo = Grit::Repo.new theme.path #issues 259
    sha = repo.commits(nil, 1).first.sha[0, 10]
    name = "#{Pinyin.t(theme.name.gsub(' ', '-'))}-#{sha}.tar.gz"
    tar_gz_content = repo.archive_tar_gz # 不保存为文件，直接将文件内容发送 http://j.mp/nGqbZ4

    ThemeMailer.export(shop, name, tar_gz_content).deliver # 发到管理员邮箱
  end

end
