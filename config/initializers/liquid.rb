# encoding: utf-8
# 全局注册过滤器
[BaseFilter, UrlFilter, TagFilter].each do |filter|
  Liquid::Template.register_filter filter
end

[Paginate].each do |tag|
  Liquid::Template.register_tag(tag.name.downcase, tag)
end

module Liquid

    module StandardFilters

      # 修正: 原生date filter不支持'now'参数???
      def date_with_string(input, format)
        input = Time.now if input == 'now'
        date_without_string(input, format)
      end

      alias_method_chain :date, :string

    end

end
