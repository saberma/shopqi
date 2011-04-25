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

end
