class Shop::CustomerAddressesController < Shop::AppController
  prepend_before_filter :authenticate_customer!
  skip_before_filter :must_has_theme
  #layout 'shop/admin'

  expose(:customer_addresses){
    current_customer.addresses
  }
  expose(:customer_address)
  expose(:shop){ current_customer.shop }
  expose(:countries){ shop.countries }

  def index
    path = Rails.root.join 'app/views/shop/templates/customers/addresses.liquid'
    assign = template_assign('customer' => CustomerDrop.new(current_customer))
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign('customers', assign))
    render text: html
  end

  def create
    if params[:address][:default_address] == '1'
      customer_addresses.update_all default_address: false
    end
    customer_address.attributes =  params[:address]
    customer_address.save
    redirect_to customer_addresses_path
  end

  def update
    if params[:customer_address][:default_address] == '1'
      customer_addresses.update_all default_address: false
    end
    customer_address.attributes =  params[:address]
    customer_address.save
    redirect_to customer_addresses_path
  end

  def destroy
    customer_address.destroy
    redirect_to customer_addresses_path
  end

end
