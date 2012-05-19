#encoding: utf-8
require 'spec_helper'

describe Admin::ProductOptionsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user_admin) }

  let(:shop) { user.shop }

  let(:iphone4) {Factory(:iphone4, shop: shop)}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#move' do

    before do
      iphone4.options_attributes = [
        {name: '大小', value: '16G'},
        {name: '网络', value: 'WIFI'},
      ]
      iphone4.save
      iphone4.reload # 注意要reload，使option的value重置为空
    end

    it "should be success" do
      iphone4
      post :move, product_id: iphone4.id, id: iphone4.options.third.id, dir: -1
      response.should be_success
    end

  end

end
