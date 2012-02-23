#encoding: utf-8
require 'spec_helper'

describe CustomerDrop do

  let(:shop) { Factory(:user).shop }

  let(:customer){ Factory(:customer_saberma, shop: shop) }

  let(:customer_drop){ CustomerDrop.new customer }

  let(:payment) { Factory :payment, shop: shop }

  let(:order) { Factory(:order, shop: shop, customer: customer, shipping_rate: '普通快递-10.0', payment_id: payment.id ) }

  let(:order_drop) { OrderDrop.new order }

  it 'should get email' do
    variant = "{{ customer.email }}"
    liquid(variant).should eql "#{customer.email}"
  end

  it 'should get name' do
    variant = "{{ customer.name }}"
    liquid(variant).should eql "#{customer.name}"
  end

  it 'should get addresses_count' do
    variant = "{{ customer.addresses_count }}"
    liquid(variant).should eql "#{customer.addresses.size}"
  end

  it 'should get orders' do
    order
    variant = "{{ customer.orders | size }}"
    liquid(variant).should eql "#{customer.orders.size}"
  end

  it "should get addresses" do
    variant = "{{ customer.addresses | size }}"
    liquid(variant).should eql "#{customer.addresses.size}"
  end


  describe CustomerAddressDrop do

    it 'should get country' do
      variant = "{{ customer.default_address.country }}"
      liquid(variant).should eql "中国"
    end

    it "should get detail address" ,focus: true do
      variant = "{{ customer.default_address.detail_address }}"
      liquid(variant).should eql "中国 广东省深圳市南山区311"
    end

    it "should get  address name" ,focus: true do
      variant = "{{ customer.default_address.name }}"
      liquid(variant).should eql "马海波"
    end

    it "should get  address company" ,focus: true do
      variant = "{{ customer.default_address.company }}"
      liquid(variant).should eql "ShopQi"
    end

    it 'should get province_code' do
      variant = "{{ customer.default_address.province_code }}"
      liquid(variant).should eql "广东省"
    end

    it 'should get city' do
      variant = "{{ customer.default_address.city }}"
      liquid(variant).should eql "深圳市"
    end

    it 'should get zip' do
      variant = "{{ customer.default_address.zip }}"
      liquid(variant).should eql "517058"
    end

    it 'should get phone' do
      variant = "{{ customer.default_address.phone }}"
      liquid(variant).should eql "13928452888"
    end

    it 'should get address1' do
      variant = "{{ customer.default_address.address1 }}"
      liquid(variant).should eql "311"
    end

  end

  describe OrderDrop do

    it 'should get orders' do
      order
      variant = "{{ customer.orders | size }}"
      liquid(variant).should eql "#{customer.orders.size}"
    end

  end

  private
  def liquid(variant, assign = {'customer' => customer_drop})
    Liquid::Template.parse(variant).render(assign)
  end

end


