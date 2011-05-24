# encoding: utf-8
module ApplicationHelper

  #用于获取当前用户请求的商店
  def shop
    current_user ? current_user.shop : Shop.where(:permanent_domain => request.subdomain).first 
  end


  def use_kindeditor
    content_for :kindeditor do 
      javascript_include_tag("kindeditor/kindeditor-min","kindeditor/kindeditor_config")
    end
  end

  def use_javascripts(*args)
    content_for :javascripts do 
      javascript_include_tag(*args)
    end
  end

  #后台管理顶端菜单
  def menus
    @menus ||= [
      { label: '订单', url: '/admin/orders' },
      { label: '会员', url: '/admin/customers' },
      { label: '商品', url: products_path },
      { label: '集合', url: custom_collections_path },
      { label: '博客 & 页面', url: pages_path },
      { label: '链接列表', url: link_lists_path },
      { label: '市场营销', url: '/admin/marketing' }
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
end
