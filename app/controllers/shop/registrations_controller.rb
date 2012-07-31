#encoding: utf-8
class Shop::RegistrationsController < Shop::AppController
  skip_before_filter :must_has_theme
  include Shop::OrderHelper
  expose(:shop) { Shop.at(request.host) }

  def new
    path = Rails.root.join 'app/views/shop/templates/customers/registrations.liquid'
    options = {'template' => 'customers'}
    options.merge!('customer' => CustomerDrop.new(customer)) if @customer
    assign = template_assign(options)
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  def create
    @customer = shop.customers.build params[:customer]

    if @customer.save
      sign_in(@customer)
      if checkout_url # 跳转到结算页面
        token = checkout_url.gsub(/.+\//,'')
        if cart = Cart.find_by_token(token)
         cart.customer = @customer
         cart.save!
        end
        redirect_to checkout_url and return
      else
        redirect_to after_sign_in_path_for(:customer, @customer) and return
      end
    else
      new
    end
  end
end
