#encoding: utf-8
require 'spec_helper'

describe Shop::AccountController do
  include Devise::TestHelpers

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user_admin).shop
    model.update_attributes password_enabled: false
    model
  end

  let(:customer) { Factory(:customer_saberma, shop: shop) }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:payment) { Factory :payment, shop: shop }

  let(:order) do
    o = Factory.build(:order, shop: shop, shipping_rate: '普通快递-10.0', payment_id: payment.id)
    o.line_items.build product_variant: variant, price: variant.price, quantity: 1
    o.save
    o
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:customer] # http://j.mp/v4MP0i
    shop.themes.install theme_dark
    request.host = "#{shop.primary_domain.host}"
    sign_in(customer)
  end

  context 'exists custom customer template' do

    it 'should be index' do
      path = shop.theme.template_path('customers/account')
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'w') {|f| f.write('自定义内容') }
      get :index
      response.body.should include '自定义内容'
    end

    it 'should show order' do
      path = shop.theme.template_path('customers/order')
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'w') {|f| f.write('自定义内容') }
      get :show_order, token: order.token
      response.body.should include '自定义内容'
    end

  end

end
