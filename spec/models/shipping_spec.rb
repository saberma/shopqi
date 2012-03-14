# encoding: utf-8
require 'spec_helper'

describe Shipping do

  let(:shop) { Factory(:user).shop }

  let(:guangdong) { '440000' }

  let(:shenzhen) { '440300' }

  let(:nanshan) { '440305' }

  let(:weight) { 0.5 } # 商品重量0.5kg

  let(:price) { 50 } # 价格50元

  it 'should get rate' do
    shop.shippings.rates(weight, price, nanshan).map(&:shipping_rate).join(',').should eql '普通快递-10.0'
  end

  context 'with province shipping' do # 指定某个省的物流

    let(:province_shipping) { Factory(:shipping, shop: shop, code: guangdong) } # 广东省

    let(:weight_based_shipping_rate){ Factory(:weight_based_shipping_rate, shipping: province_shipping, name: '特快专递EMS') }

    before { weight_based_shipping_rate }

    it 'should get rate' do
      shop.shippings.rates(weight, price, nanshan).map(&:shipping_rate).join(',').should eql '特快专递EMS-10.0'
    end

  end

  context 'with city shipping' do # 指定某个市的物流

    let(:city_shipping) { Factory(:shipping, shop: shop, code: shenzhen) } # 深圳市

    let(:weight_based_shipping_rate){ Factory(:weight_based_shipping_rate, shipping: city_shipping, name: '特快专递EMS') }

    before { weight_based_shipping_rate }

    it 'should get rate' do
      shop.shippings.rates(weight, price, nanshan).map(&:shipping_rate).join(',').should eql '特快专递EMS-10.0'
    end

  end

  context 'with district shipping' do # 指定某个区的物流

    let(:district_shipping) { Factory(:shipping, shop: shop, code: nanshan) } # 南山区

    let(:weight_based_shipping_rate){ Factory(:weight_based_shipping_rate, shipping: district_shipping, name: '特快专递EMS') }

    before { weight_based_shipping_rate }

    it 'should get rate' do
      shop.shippings.rates(weight, price, nanshan).map(&:shipping_rate).join(',').should eql '特快专递EMS-10.0'
    end

  end

  describe PriceBasedShippingRate do # 基于价格

    let(:weight) { 30 } # 商品重量30kg，不显示基于重量的记录(默认上限为25kg)

    let(:price) { 22 } # 价格22元

    let(:shipping){ shop.shippings.first } # 全国

    let(:price_based_shipping_rate_without_max){ shipping.price_based_shipping_rates.create name: '顺丰快递', min_order_subtotal: 50, price: price } # 无价格上限

    let(:price_based_shipping_rate_with_max){ shipping.price_based_shipping_rates.create name: '顺丰快递', min_order_subtotal: 50, max_order_subtotal: 100, price: price } # 有价格上限

    context 'without max' do

      before { price_based_shipping_rate_without_max }

      it 'should get rate' do
        shop.shippings.rates(weight, 50, nanshan).map(&:shipping_rate).join(',').should eql '顺丰快递-22.0'
      end

    end

    context 'with max' do

      before { price_based_shipping_rate_with_max }

      it 'should get rate' do
        shop.shippings.rates(weight, 50, nanshan).map(&:shipping_rate).join(',').should eql '顺丰快递-22.0'
      end

    end

  end

end
