#encoding: utf-8
class Admin::EmailsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){ current_user.shop }
  expose(:users){ shop.users }
  expose(:emails){ shop.emails }
  expose(:email)
  expose(:subscribes){ shop.subscribes }
  expose(:subscribe)

  def index
  end

  def update
    email.save
    redirect_to notifications_path , notice: notice_msg
  end

  def follow
    sub = params[:subscribe_type]
    address = params[:address]
    if sub == 'email'
      subscribe.address = address
      unless subscribe.save
        flash[:error] = subscribe.errors.full_messages[0]
        render template: "shared/error_msg"
        return
      end
    else
      subscribe.user_id = sub
      subscribe.save
    end
  end

  def unfollow
    subscribe.destroy
  end

  def preview
    order = demo_order
    order_drop = OrderDrop.new(order)
    fulfillment_drop = OrderFulfillmentDrop.new(demo_fulfillment(order))
    assign = order_drop.as_json.merge('shop' => ShopDrop.new(shop), 'fulfillment' => fulfillment_drop, 'is_email' => true) # email的币种字符与html的不同
    body = params[:email][:body_html]
    body = params[:email][:body] if params[:view_type] == 'text'
    @subject = Liquid::Template.parse(params[:email][:title]).render(assign)
    @body = Liquid::Template.parse(body).render(assign)
    render action: 'preview',layout: false
  end

  private
  def demo_order
    order = shop.orders.new({
      id: 9999,
      email: "mahb45@gmail.com",
      shipping_address_attributes: {
        name: '马海波',
        province: '440000',
        city: '440300',
        district: '440305',
        address1: '科技园南区6栋311',
        zip: '518057',
        phone: '13928452888'
      }
    })
    order.order_number = 9999
    order.name = shop.order_number_format.gsub /{{number}}/, order.order_number.to_s
    variant = shop.variants.first # 商品款式
    order.line_items.build(product_variant: variant, price: variant.price, quantity: 1).before_create
    order.total_line_items_price = order.line_items.map(&:total_price).sum
    order.total_price = order.total_line_items_price + order.tax_price
    address = order.shipping_address # 顾客地址
    customer = shop.customers.new email: order.email, name: order.shipping_address.name
    customer.addresses.new(name: address.name, company: address.company, country_code: address.country_code, province: address.province, city: address.city, district: address.district, address1: address.address1, address2: address.address2, zip: address.zip, phone: address.phone)
    order.customer = customer
    order.shipping_rate = '普通快递 - 10'
    order.payment = shop.payments.first
    order.cancel_reason = 'customer'
    order.created_at = DateTime.now
    order
  end

  def demo_fulfillment(order) # 物流信息
    fulfillment = order.fulfillments.new tracking_number: '1234', tracking_company: 'EMS'
    fulfillment.line_items << order.line_items.first
    fulfillment
  end

end
