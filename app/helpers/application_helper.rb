module ApplicationHelper

  #用于获取当前用户请求的商店
  def shop
    current_user ? current_user.shop : Shop.where(:permanent_domain => request.subdomain).first 
  end

end
