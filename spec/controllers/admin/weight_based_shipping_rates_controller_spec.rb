#encoding: utf-8
require 'spec_helper'

describe Admin::WeightBasedShippingRatesController do
  include Devise::TestHelpers
  let(:user) { Factory(:user_liwh) }
  let(:shop) { user.shop }
  let(:shipping){ Factory(:shipping, shop: shop) }
  let(:weight_based_shipping_rate){ Factory(:weight_based_shipping_rate, shipping: shipping)}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#create' do

    it "success" do
      expect do
        xhr :post, :create, shipping_id: shipping.id, weight_based_shipping_rate: {weight_low: 0.0, weight_high: 10.0, name: '顺丰快递'}
      end.to change(WeightBasedShippingRate,:count).by(1)
    end

    it "failure" do
      expect do
        xhr :post, :create, shipping_id: shipping.id, weight_based_shipping_rate: {weight_low: 0.0, weight_high: 10.0, name: ''}
      end.to change(WeightBasedShippingRate,:count).by(0)
    end

  end

  context "#edit" do

    it "success" do
      put :update, id: weight_based_shipping_rate.id, shipping_id: shipping.id, weight_based_shipping_rate: { weight_low: 1.0, weight_high: 11.0, name: '顺丰快递', price: 20}
      response.should be_redirect
      weight_based_shipping_rate.reload
      weight_based_shipping_rate.name.should eql '顺丰快递'
    end

  end

end
