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

  #后台管理顶端菜单
  def menus
    @menus ||= [
      { label: '订单', url: '/admin/orders' },
      { label: '会员', url: '/admin/customers' },
      { label: '商品', url: products_path },
      { label: '集合', url: '/admin/custom_collections' },
      { label: '博客 & 页面', url: pages_path },
      { label: '链接列表', url: link_lists_path },
      { label: '市场营销', url: '/admin/marketing' }
    ]
    @menus
  end

  #是否为当前页面
  def current(menu)
    (current_page?(menu[:url]) ? :current : '')
  end

end
