# encoding: utf-8
# 全局注册过滤器
[BaseFilter, UrlFilter, TagFilter].each do |filter|
  Liquid::Template.register_filter filter
end
