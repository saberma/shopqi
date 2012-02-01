# encoding: utf-8
require 'spec_helper'

describe Photo do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  context '#create' do

    context 'shop storage is not idle' do # 容量已经用完

      it "should be fail" do
        photo = iphone4.photos.build
        photo.product_image = Rails.root.join('spec/factories/data/products/iphone4.jpg')
        photo.shop.stub!(:storage_idle?) { false }
        photo.save
        photo.errors.should_not be_empty
      end

    end

  end

end
