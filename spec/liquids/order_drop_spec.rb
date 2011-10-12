#encoding: utf-8
require 'spec_helper'

describe OrderDrop do
  let(:shop) { Factory(:user).shop }
  let(:customer){ Factory(:customer_liwh, shop: shop)}
  let(:order) { Factory(:order_liwh, shop: shop, customer: customer)}
  let(:order_drop) { OrderDrop.new order}

  it 'should get the order based delegate attributes for order_drop' do
    variant = "{{ order.id }}"
    liquid(variant).should eql "#{order.id}"

    variant = "{{ order.name }}"
    liquid(variant).should eql "#{order.name}"

    variant = "{{ order.order_number }}"
    liquid(variant).should eql "#{order.order_number}"

    variant = "{{ order.shipping_rate }}"
    liquid(variant).should eql "#{order.shipping_rate}"

  end

  private
  def liquid(variant, assign = {'order' => order_drop})
    Liquid::Template.parse(variant).render(assign)
  end

end


