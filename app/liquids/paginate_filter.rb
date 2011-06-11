# encoding: utf-8
module PaginateFilter

  def default_pagination(paginate)
    current_page = paginate['current_page']
    pages = paginate['pages']
    result = ''
    if paginate['previous']
      result += %Q( <span class="prev"><a href="#{paginate['previous']['url']}">« #{paginate['previous']['title']}</a></span>)
    end
    paginate['parts'].each do |part|
      page =  part['title']
      if page == (current_page + 3) and page != pages
        result += %Q( <span class="deco">...</span>)
      elsif page > (current_page + 3) and page != pages #省略
      elsif page == (current_page - 3) and page != 1
        result += %Q( <span class="deco">...</span>)
      elsif page < (current_page - 3) and page != 1 #省略
      else
        if part['is_link']
          result += %Q( <span class="page"><a href="#{part['url']}">#{page}</a></span>)
        else
          result += %Q( <span class="page current">#{page}</span>)
        end
      end
    end
    if paginate['next']
      result += %Q( <span class="next"><a href="#{paginate['next']['url']}">#{paginate['next']['title']} »</a></span>)
    end
    result
  end

end
