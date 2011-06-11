class Paginate < Liquid::Block
  Syntax = /(#{Liquid::VariableSignature}+)\s+by\s+(\d+)/

  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @collection_name = $1
      @size = $2.to_i
    else
      raise Liquid::SyntaxError.new("Syntax Error in 'paginate' - Valid syntax: paginate [collection] by [size]")
    end
    super
  end

  def render(context)
    collection = context[@collection_name] or return ''
    current_page = (context['current_page'] || 1).to_i
    items = collection.size
    pages = (items + @size -1) / @size
    in_page_collection = collection[(current_page-1)*@size, @size]
    collection.reject! {|item| !in_page_collection.include?(item)} #注意:drop中的集合要缓存，否则替换后还是会没有用

    context.stack do

      context['paginate'] = {
        'page_size'  => @size,
        'current_page'  => current_page,
        'current_offset'  => current_page * @size,
        'pages'  => pages,
        'items'  => items,
      }
      if current_page > 1
        context['paginate']['previous'] = { 'url' => "?page=#{current_page - 1}", 'title' => 'Previous' }
      end
      context['paginate']['parts'] = (1..pages).map do |page|
        { 'url' => "?page=#{page}", 'title' => page, 'is_link' => (page != current_page) }
      end
      if current_page < pages
        context['paginate']['next'] = { 'url' => "?page=#{current_page + 1}", 'title' => 'Next' }
      end

      super
    end
  end
end
