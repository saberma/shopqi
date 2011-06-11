# encoding: utf-8
module PaginateFilter

  def default_pagination(paginate)
    result = ''
    if paginate['previous']
      result += %Q( <span class="prev"><a href="#{paginate['previous']['url']}">« #{paginate['previous']['title']}</a></span>)
    end
    paginate['parts'].each do |part|
      if part['is_link']
        result += %Q( <span class="page"><a href="#{part['url']}">#{part['title']}</a></span>)
      else
        result += %Q( <span class="page current">#{part['title']}</span>)
      end
    end
    if paginate['next']
      result += %Q( <span class="next"><a href="#{paginate['next']['url']}">#{paginate['next']['title']} »</a></span>)
    end
    result
  end

end
