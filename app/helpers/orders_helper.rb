#encoding: utf-8
module OrdersHelper

  #查询条件链接需要存储上一次的查询条件
  def order_search_path(current_search)
    search_path(:orders_path, current_search)
  end

end
