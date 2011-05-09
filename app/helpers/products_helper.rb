#encoding: utf-8
module ProductsHelper

  #查询条件链接需要存储上一次的查询条件
  def search_path(current_search)
    if params[:search]
      current_search = params[:search].symbolize_keys.merge(current_search)
    end
    current_search.delete_if {|key, value| value.blank? }
    products_path(search: current_search)
  end

  #查询标签
  def search_label(params_key, plain_label)
    (params[:search] && params[:search][params_key]) || plain_label
  end

end
