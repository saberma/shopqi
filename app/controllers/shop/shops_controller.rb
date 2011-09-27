# encoding: utf-8
#class Shop::ShopsController < Shop::ApplicationController #warning: toplevel constant ApplicationController referenced by
class Shop::ShopsController < Shop::AppController
  include Admin::ShopsHelper
  skip_before_filter :password_protected, only: :password

  expose(:shop) do
    if params[:id]
      Shop.find(params[:id]) #checkout页面
    else
      Shop.at(request.host)
    end
  end

  def show
    if params[:preview_theme_id] # 预览主题
      session[:preview_theme_id] = params[:preview_theme_id]
      redirect_to preview_theme_id: nil and return
    end
    layout_content = File.read(theme.layout_theme_path)
    unless session[:preview_theme_id].blank?
      layout_content.sub! '</head>', %Q(
<script type="text/javascript">
  var ShopQi = ShopQi || {};
  ShopQi.theme = {"name":"#{theme.name}","id":"#{theme.id}"};
</script>
<script type="text/javascript">
  //<![CDATA[
    (function() {
      function asyncLoad() {
        var urls = ["/s/global/theme-controls.js"];
        for (var i = 0; i < urls.length; i++) {
          var s = document.createElement('script');
          s.type = 'text/javascript';
          s.async = true;
          s.src = urls[i];
          var x = document.getElementsByTagName('script')[0];
          x.parentNode.insertBefore(s, x);
        }
      }
      window.attachEvent ? window.attachEvent('onload', asyncLoad) : window.addEventListener('load', asyncLoad, false);
    })();
  //]]>
</script>
<link rel="stylesheet" href="/s/global/theme-controls.css" type="text/css" />
</head>
      )
    end
    html = Liquid::Template.parse(layout_content).render(shop_assign)
    render text: html
  end

  # 附件
  def asset
    asset = "#{params[:file]}.#{params[:format]}" # style.css
    theme = shop.themes.find(params[:theme_id])
    html = Liquid::Template.parse(File.read(theme.asset_path(asset))).render(asset_assign)
    render text: html
  end

  def password # 提示密码
    if request.post?
      if params[:password] == shop.password
        session['storefront_digest'] = true
        redirect_to '/'
      else
        flash[:error] = '密码不正确，请重试.'
      end
    end
  end
end
