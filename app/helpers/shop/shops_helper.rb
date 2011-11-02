# encoding: utf-8
module Shop::ShopsHelper

  def theme # 支持主题预览
    id = session[:preview_theme_id]
    (!id.blank? && shop.themes.exists?(id) && shop.themes.find(id)) || shop.theme
  end

  def checkout_css_exists? # 主题存在checkout.css附件(暂时只支持当前主题，不支持主题预览)
    css_path = File.join theme.path, 'assets', 'checkout.css'
    liquid_path = "#{css_path}.liquid"
    File.exists?(liquid_path) || File.exists?(css_path)
  end

end
