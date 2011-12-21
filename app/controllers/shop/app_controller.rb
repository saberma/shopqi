# encoding: utf-8
class Shop::AppController < ActionController::Base
  include Admin::ShopsHelper
  include Shop::ShopsHelper
  layout nil #默认不需要layout，使用liquid
  before_filter :check_shop_access_enabled
  before_filter :force_domain # 域名管理中是否设置主域名重定向
  before_filter :check_shop_avaliable # 判断网店是否已过期
  before_filter :password_protected # 设置了密码保护
  before_filter :must_has_theme # 必须存在主题
  before_filter :remove_preview_theme_query_string # url去掉preview_theme_id
  rescue_from StandardError                 , with: :rescue_other
  rescue_from ActiveRecord::RecordNotFound  , with: :rescue_some
  rescue_from ActionController::RoutingError, with: :rescue_some

  #protect_from_forgery #theme各个页面中的form都没有csrf，导致post action获取不到session id

  protected
  def check_shop_access_enabled
    render template: 'shared/no_shop.html', content_type: "text/html", status: 404, layout: nil and return unless shop.access_enabled
  end
  def check_shop_avaliable
    redirect_to controller: :shops, action: :unavailable and return unless shop.available?
  end

  def must_has_theme
    redirect_to controller: :shops, action: :themes and return  unless shop.theme
  end

  def force_domain
    host = request.host
    shop_domain = ShopDomain.from(host)
    return unless shop_domain # 排除checkout页面
    primary = shop_domain.shop.primary_domain
    if primary.force_domain and host != primary.host  # 重定向
      redirect_to "#{request.protocol}#{primary.host}#{request.port_string}#{request.path}" and return
    end
  end

  def password_protected
    if shop.password_enabled and !session['storefront_digest']
      redirect_to controller: :shops, action: :password and return
    end
  end

  def remove_preview_theme_query_string
    if params[:preview_theme_id] # 预览主题
      session[:preview_theme_id] = params[:preview_theme_id]
      redirect_to preview_theme_id: nil and return
    end
  end

  begin 'liquid'

    def shop_assign(template = 'index', template_extra_object = {}) # 渲染layout时的hash
      template_extra_object['template'] = template # templates模板中也需要此变量
      powered_by_link = Rails.cache.fetch "shopqi_snippets_powered_by_link" do
        content = File.read(Rails.root.join('app', 'views', 'shop', 'snippets', 'powered_by_link.liquid'))
        Liquid::Template.parse(content).render('url_with_port'=>url_with_port)
      end
      unless template_extra_object.key?('content_for_layout')
        content_for_layout = Liquid::Template.parse(File.read(theme.template_path(template))).render(template_assign(template_extra_object))
      else
        content_for_layout = template_extra_object['content_for_layout']
      end
      {
        'content_for_header' => '',
        'content_for_layout' => content_for_layout,
        'powered_by_link' => powered_by_link,
        'page_title' =>  get_current_page_title(template,template_extra_object)
      }.merge template_extra_object # layout也需要product变量，显示description
    end

    # 渲染template时的hash
    def template_assign(extra_assign = {})
      shop_drop = ShopDrop.new(shop, theme)
      settings_drop = SettingsDrop.new(theme)
      linklists_drop = LinkListsDrop.new(shop)
      collections_drop = CollectionsDrop.new(shop)
      pages_drop = PagesDrop.new(shop)
      blogs_drop = BlogsDrop.new(shop)
      drops = {
        'shop' => shop_drop,
        'cart' => cart_drop,
        'settings' => settings_drop,
        'linklists' => linklists_drop,
        'blogs' => blogs_drop,
        'collections' => collections_drop,
        'current_page' => params[:page],
        'current_url' => request.path,
      }
      drops['customer'] = CustomerDrop.new(current_customer) if current_customer
      drops['params'] = params # 方便form liquid进一步处理
      drops.merge(extra_assign)
    end

    def cart_drop
      CartDrop.new(session_cart_hash)
    end

    def get_current_page_title(template,template_extra_object)
      case template
      when 'index'      ; '欢迎光临'
      when 'page'       ; template_extra_object['page'].title
      when 'product'    ; template_extra_object['product'].title
      when 'blog'       ; template_extra_object['blog'].title
      when 'collection' ; template_extra_object['collection'].title
      when 'article'    ; template_extra_object['article'].title
      when 'search'     ; '查询'
      when 'cart'       ; '购物车'
      else ; '' end
    end

  end

  begin 'cart'

    def cart_key # 存储在redis中的cart
      Cart.key(shop, cart_session_id)
    end

    def session_cart_hash # {variant_id: quantity}
      cart = Resque.redis.hgetall cart_key
      cart.inject({}) do |result, (key, value)| # 注意,redis获取的value为字符串
        result[key.to_i] = value.to_i if shop.variants.exists?(key.to_i) # 款式已经被删除，但顾客浏览器的cookie还存在id
        result
      end
    end

  end

  begin 'script' # 加入网页的脚本(统计、预览主题提示等)

    def layout_content
      content = File.read(theme.layout_theme_path)
      unless session[:preview_theme_id].blank?
        theme_controls_path = Rails.root.join 'app', 'views', 'shop', 'snippets', 'theme-controls.liquid'
        theme_controls_content = Rails.cache.fetch "shopqi_snippets_theme_controls" do
          File.read(theme_controls_path)
        end
        content.sub! '</head>', theme_controls_content
      end
      content
    end

  end

  def cart_session_id # 获取当前请求的session id
    session['cart_session_id'] ||= request.session_options[:id]
  end

  begin 'rescue' # 出错显示404页面

    def rescue_some(exception) # 找不到记录、路由不正确等的普通错误
      show_errors(exception)
    end

    def rescue_other(exception) # 其他错误，详细记录
      logger.error(exception.backtrace.join("\n"))
      show_errors(exception)
    end

    def show_errors(exception) # 出错显示404页面
      assign = template_assign
      html = Liquid::Template.parse(layout_content).render(shop_assign('404', assign))
      render text: html, status: 404
    end

  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||  customer_account_index_path
  end

end
