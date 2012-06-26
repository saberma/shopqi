require 'spec_helper'

describe Kindeditor do

  let(:shop) { Factory(:user).shop }

  context '#create' do

    let(:photo) do
      model = shop.kindeditors.build
      model.kindeditor_image = Rails.root.join('spec/factories/data/products/iphone4.jpg')
      model
    end

    it "should get url" do
      ActionController::Base.asset_host = "//lvh.me"
      photo.save
      photo.url.should eql "//lvh.me#{photo.kindeditor_image.url}"
    end

    context 'shop storage is not idle' do # 容量已经用完

      it "should be fail" do
        photo.shop.stub!(:storage_idle?) { false }
        photo.save
        photo.errors.full_messages.join(',').should_not be_blank
      end

    end

  end

end
