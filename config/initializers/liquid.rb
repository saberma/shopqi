# encoding: utf-8
# 全局注册过滤器
[BaseFilter, UrlFilter, TagFilter, PaginateFilter].each do |filter|
  Liquid::Template.register_filter filter
end

[Paginate,Form].each do |tag|
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

  begin '支持include snippet路径搜索'

    class Include

      def render_with_file_system(context) # 修正: 商店首页(woodland主题)错误This liquid context does not allow includes
        shop = context['shop'].instance_variable_get('@shop')
        context.registers[:file_system] = Liquid::SnippetFileSystem.new(File.join(shop.theme.path, 'snippets'))
        render_without_file_system(context)
      end

      alias_method_chain :render, :file_system

    end

    class SnippetFileSystem < LocalFileSystem # 用于include标记

      def full_path(template_path)
        #raise FileSystemError, "Illegal template name '#{template_path}'" unless template_path =~ /^[^.\/][a-zA-Z0-9_\/]+$/
        raise FileSystemError, "Illegal template name '#{template_path}'" unless template_path =~ /^[^.\/][a-zA-Z0-9_\/\-]+$/ # 名称可以包含横杠(-)

        full_path = if template_path.include?('/')
          #File.join(root, File.dirname(template_path), "_#{File.basename(template_path)}.liquid")
          File.join(root, File.dirname(template_path), "#{File.basename(template_path)}.liquid") # 默认不加上下划线前缀
        else
          #File.join(root, "_#{template_path}.liquid")
          File.join(root, "#{template_path}.liquid")
        end

        raise FileSystemError, "Illegal template path '#{File.expand_path(full_path)}'" unless File.expand_path(full_path) =~ /^#{File.expand_path(root)}/

        full_path
      end

    end

  end

end
