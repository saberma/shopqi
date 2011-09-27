#encoding: utf-8
require 'spec_helper'

describe Admin::WeightBasedShippingRatesController do
  include Devise::TestHelpers
  let(:weight_based_shipping_rate){ Factory(:weight_based_shipping_rate)}
  let(:c){ Factory(:country)}
  let(:user) { Factory(:user_liwh) }
  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(Factory(:user_admin))
  end

  context '#create' do
    it "success" do
      expect do
        xhr :post, :create,weight_based_shipping_rate: {weight_low: 0.0, weight_high: 10.0, country_id: c.id, name: '顺风'}
      end.should change(WeightBasedShippingRate,:count).by(1)
    end

    it "failure" do
      expect do
        xhr :post, :create,weight_based_shipping_rate: {weight_low: 0.0, weight_high: 10.0, country_id: c.id, name: ''}
      end.should change(WeightBasedShippingRate,:count).by(0)
    end
  end

  context "#edit" do
    it "success" do
      put :update, weight_based_shipping_rate: { weight_low: 1.0, weight_high: 11.0,name: 'EMS', price: 20}, id: weight_based_shipping_rate.id
      response.should be_redirect
      weight_based_shipping_rate.reload
      weight_based_shipping_rate.name.should eql 'EMS'
    end

  end


end
