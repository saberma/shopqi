#encoding: utf-8
module Admin::ProductsHelper

  #查询条件链接需要存储上一次的查询条件
  def product_search_path(current_search)
    search_path(:products_path, current_search)
  end

end
