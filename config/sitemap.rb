# https://github.com/kjvarga/sitemap_generator
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/shopqi"

# shopqi
SitemapGenerator::Sitemap.create default_host: "http://www.#{Setting.host}" do

  add '/faq'
  add '/about'
  add '/tour'
  add '/tour/store'
  add '/tour/design'
  add '/tour/security'
  add '/tour/features'
  add '/agreement'
  add '/signup'

end

# theme # 记录由ajax获取显示，不需要被采集

# wiki # 待完善
