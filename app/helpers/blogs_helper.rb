module BlogsHelper

  #查询条件链接需要存储上一次的查询条件
  def blog_search_path(blog,current_search)
    search_path(:blog_path, current_search, blog)
  end

end
