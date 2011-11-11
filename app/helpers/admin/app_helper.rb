# encoding: utf-8
module Admin::AppHelper

  #用于获取当前用户请求的商店
  def shop
    if current_user
      current_user.shop
    else
      Shop.at(request.host)
    end
  end

  def link_to_delete(path)
    link_to image_tag('admin/icons/trash.gif'), path, remote: true, method: :delete, confirm: '您确定要删除?', title: '删除它', class: :del
  end

  def use_kindeditor
    content_for :kindeditor do
      %Q(
        <script src="/javascripts/kindeditor/kindeditor.js?1" type="text/javascript"></script>
        <script src="/javascripts/kindeditor/kindeditor_config.js?1" type="text/javascript"></script>
      ).html_safe
    end
  end

  def dialog(title, &block) # 弹出窗口
    render 'shared/block', title: title, body: capture(&block)
  end

  def high_color(title,color='red')
    "<span style='color:#{color}'>#{title}</span>"
  end

  #后台管理顶端菜单
  def menus
    @menus ||= [
      { label: orders_menu_label, url: orders_path },
      { label: '顾客', url: customers_path },
      { label: '商品', url: products_path },
      { label: '集合', url: custom_collections_path },
      { label: '博客 & 页面', url: pages_path },
      { label: '链接列表', url: link_lists_path },
      #{ label: '市场营销', url: "javascript:msg('即将上线...')" }
    ]
    @menus
  end

  #是否为当前页面
  def current(menu)
    #(current_page?(menu[:url]) ? :current : '')
    request.path.start_with?(menu[:url]) ? :current : ''
  end

  #国际化
  def w(str)
    str, model = str.split('.')
    str = I18n.t "web.#{str}"
    str += I18n.t("activerecord.models.#{model}") if model
    str
  end

  #国际化显示实体属性
  def tt(str)
    t("activerecord.attributes.#{str}")
  end

  begin 'search'

    #查询条件链接需要存储上一次的查询条件
    def search_path(path,current_search, obj = nil)
      if params[:search]
        current_search = params[:search].symbolize_keys.merge(current_search)
      end
      current_search.delete_if {|key, value| value.blank? }
      send(path, obj, search: current_search) #products_path(search: current_search)
    end

    #查询标签
    def search_label(params_key, plain_label, values={})
      key = "#{params_key}_eq"
      if params[:search] and params[:search][key]
        value = params[:search][key]
        values[value] || value
      else
        plain_label
      end
    end

  end

end
