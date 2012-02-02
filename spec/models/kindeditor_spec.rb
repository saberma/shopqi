require 'spec_helper'

describe Kindeditor do

  let(:shop) { Factory(:user).shop }

  context '#create' do

    context 'shop storage is not idle' do # 容量已经用完

      it "should be fail" do
        photo = shop.kindeditors.build
        photo.kindeditor_image = Rails.root.join('spec/factories/data/products/iphone4.jpg')
        photo.shop.stub!(:storage_idle?) { false }
        photo.save
        photo.errors.full_messages.join(',').should_not be_blank
      end

    end

  end

end
