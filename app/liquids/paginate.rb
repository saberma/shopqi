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
    in_page_collection = collection[(current_page-1)*@size, @size]

    context.stack do

      context['paginate'] = {
        'page_size'  => @size,
        'current_page'  => current_page,
        'current_offset'  => current_page,
        'pages'  => (collection.size + @size -1) / @size,
        'items'  => in_page_collection.size
      }

      #替换同名集合为当前页Item #a = 'a.b.c' #{a: {b: {c: 1}}}
      result = context
      names = @collection_name.split('.')
      names.each do |name|
        result[name] = (name == names.last) ? in_page_collection : {}
        result=result[name]
      end

      super
    end
  end
end
