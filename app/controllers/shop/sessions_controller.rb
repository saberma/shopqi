#encoding: utf-8
# 顾客登录
# 1. 直接登录
# 2. 从checkout结算页面中跳转到登录页面
#    a. 登录或注册后返回
#    b. 不登录，以游客身份返回
class Shop::SessionsController < Shop::AppController
  include Shop::OrderHelper
  skip_before_filter :must_has_theme
  prepend_before_filter :allow_params_authentication!, only: :create # allow devise authen from post params
  # respond_to :html # use for create action respond_with
  expose(:shop) { Shop.at(request.host) }

  def new
    path = theme.template_path('customers/login')
    path = Rails.root.join 'app/views/shop/templates/customers/login.liquid' unless File.exist?(path)
    assign = template_assign('template' => 'customers_login', 'errors' => flash[:alert], 'recover_errors' => flash[:notice])
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  def create
    #env['warden'].logout(resource_name) #点换用户时，先清空以前session中的用户,由于warden的方法，会先从sessio中找已经存在的用户
    if params[:guest].present? and checkout_url.present?
     token = checkout_url.gsub(/.+\//,'')
      if cart = Cart.find_by_token(token)
       cart.customer = nil
       cart.save!
      end
      redirect_to checkout_url and return
    end
    customer = warden.authenticate!(scope: :customer, recall: "#{controller_path}#new") # redirect_to new action if auth fail
    sign_in customer
    if checkout_url #用于增加购物车与顾客之间的关联
      token = checkout_url.gsub(/.+\//,'')
      if cart = Cart.find_by_token(token) and !params[:guest].present?
        cart.customer = customer
        cart.save!
      end
      redirect_to checkout_url and return
    else
      redirect_to after_sign_in_path_for(customer)
    end
  end

  def destroy
    sign_out(:customer)
    redirect_to after_sign_out_path_for(:customer)
  end

end
