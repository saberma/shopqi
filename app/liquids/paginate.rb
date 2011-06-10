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
    in_page_collection = collection[(current_page-1)*@size, @size]
    collection.reject! {|item| !in_page_collection.include?(item)} #注意:drop中的集合要缓存，否则替换后还是会没有用

    context.stack do

      context['paginate'] = {
        'page_size'  => @size,
        'current_page'  => current_page,
        'current_offset'  => current_page,
        'pages'  => (items + @size -1) / @size,
        'items'  => items
      }

      super
    end
  end
end
