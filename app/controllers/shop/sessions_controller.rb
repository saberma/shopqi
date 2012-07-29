#encoding: utf-8
# 顾客登录
# 1. 直接登录
# 2. 从checkout结算页面中跳转到登录页面
#    a. 登录或注册后返回
#    b. 不登录，以游客身份返回
class Shop::SessionsController < Shop::AppController
  #prepend_before_filter :require_no_authentication, :only => [:new, :create ] #去掉此句，以便用户能更改账号付账
  #before_filter :get_host, only: :create
  include Devise::Controllers::InternalHelpers
  include Shop::OrderHelper
  skip_before_filter :must_has_theme
  prepend_before_filter :allow_params_authentication!, only: :create
  #layout 'shop/admin'
  expose(:shop) { Shop.at(request.host) }

  # GET /resource/sign_in
  def new
    resource = build_resource
    clean_up_passwords(resource)
    path = theme.template_path('customers/login')
    path = Rails.root.join 'app/views/shop/templates/customers/login.liquid' unless File.exist?(path)
    assign = template_assign('template' => 'customers_login', 'errors' => flash[:alert], 'recover_errors' => flash[:notice])
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  # POST /resource/sign_in
  def create
    env['warden'].logout(resource_name) #点换用户时，先清空以前session中的用户,由于warden的方法，会先从sessio中找已经存在的用户
    if params[:guest].present? and checkout_url.present?
     token = checkout_url.gsub(/.+\//,'')
      if cart = Cart.find_by_token(token)
       cart.customer = nil
       cart.save!
      end
      redirect_to checkout_url and return
    end
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if checkout_url #用于增加购物车与顾客之间的关联
      token = checkout_url.gsub(/.+\//,'')
      if cart = Cart.find_by_token(token) and !params[:guest].present?
        cart.customer = resource
        cart.save!
      end
      redirect_to checkout_url and return
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  # GET /resource/sign_out
  def destroy
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :signed_out if signed_in

    # We actually need to hardcode this, as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
      format.all do
        method = "to_#{request_format}"
        text = {}.respond_to?(method) ? {}.send(method) : ""
        render :text => text, :status => :ok
      end
    end
  end

  protected

  def stub_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { :methods => methods, :only => [:password] }
  end

end

