#encoding: utf-8
require 'spec_helper'

describe Admin::ProductVariantsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user_admin) }

  let(:shop) { user.shop }

  let(:iphone4) {Factory(:iphone4, shop: shop)}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#create' do

    it "should set default price and weight" do # issue#205
      iphone4
      expect do
        post :create, product_id: iphone4.id, product_variant: {option1: '16G', price: nil, weight: nil}
        response.should be_success
      end.should change(ProductVariant, :count).by(1)
    end

  end

end
