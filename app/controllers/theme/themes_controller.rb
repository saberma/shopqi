#encoding: utf-8
class Theme::ThemesController < Theme::AppController
  prepend_before_filter :authenticate_shop!, only: [:apply, :logout]
  layout 'theme', only: [:index, :show, :download, :apply]

  expose(:permanent_domain) { session[:shop] }
  expose(:shop_url) { session[:shop_url] }
  expose(:shop_host) { URI.parse(shop_url).host }
  expose(:name) { session[:name] || params[:name] }
  expose(:style) { session[:style] || params[:style] }

  begin 'store'

    def index
    end

    def show
      session[:name] = params[:name]
      session[:style] = params[:style]
      theme = Theme.find_by_name_and_style(params[:name], params[:style])
      @theme_json = theme.attributes.to_json
      styles = Theme.find_all_by_name(params[:name])
      others = Theme.find_all_by_author(theme.author).take(4)
      @styles_json = styles.inject([]) do |result, theme|
        result << theme.attributes; result
      end.to_json
      @others_json = others.inject([]) do |result, theme|
        result << { theme: theme.attributes }; result
      end.to_json
    end

    def download # 确认切换主题
      if request.xhr? # ajax
        if permanent_domain
          render text: 'logged'
        else
          redirect_to theme_login_path
        end
      else # html
        redirect_to theme_path(name: name, style: style) unless permanent_domain
      end
    end

    def get_shop # 获取商店信息
      access_token = OAuth2::AccessToken.new(client, token)
      result = JSON(access_token.get('/api/me'))
      if result['error'].blank?
        session[:shop] = result['permanent_domain']
      end
      redirect_to theme_download_path(name: name, style: style)
    end

    def apply # 切换主题
      if request.post?
        access_token = OAuth2::AccessToken.new(client, token)
        access_token.post('/api/themes/switch', name: name, style: style)
      end
    end

    def login # 未登录时提示用户登录或者注册(如果直接跳转至登录页面则对未注册用户不友好)
    end

    def logout
      session[:shop] = nil
      session[:shop_url] = nil
      redirect_to theme_path(name: name, style: style)
    end

    def authenticate # 跳转至登录页面oauth
      session[:shop_url] = params[:shop_url]
      redirect_to client.web_server.authorize_url(
        redirect_uri: Theme.redirect_uri
      )
    end

    def filter # 查询主题
      session[:q] = request.query_string
      price = params[:price]
      color = params[:color]
      themes =  Theme.all.clone # 一定要复制
      themes.select! {|t| t.price == 0} if price == 'free'
      themes.reject! {|t| t.price == 0} if price == 'paid'
      themes.select! {|t| t.color == color} unless color.blank?
      themes_json = themes.inject([]) do |result, theme|
        result << { theme: theme.attributes }; result
      end.to_json
      render json: themes_json
    end

  end


  protected
  def client
    @client ||= OAuth2::Client.new(
      Theme.client_id,
      Theme.client_secret,
      site: shop_url #'http://lvh.me:4001'
    )
  end

  def token
    shop = ShopDomain.shop(shop_host)
    consumer = OAuth2::Model::ConsumerToken.where(shop: shop, client_id: Theme.client_id).first
    consumer.access_token
  end

  def authenticate_shop! # 必须通过认证
    redirect_to theme_path(name: name, style: style) unless permanent_domain
  end
end
