#encoding: utf-8
module Admin::OrdersHelper

  #查询条件链接需要存储上一次的查询条件
  def order_search_path(current_search)
    search_path(:orders_path, current_search)
  end

  def orders_menu_label
    size = orders_size
    size > 0 ? "订单 (#{size})" : "订单"
  end

  def orders_size
    shop.orders.metasearch(status_eq: :open, financial_status_ne: :abandoned).size
  end

end
