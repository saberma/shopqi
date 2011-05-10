require 'spec_helper'

describe SmartCollectionObserver do

  let(:shop) { Factory(:user).shop }

  #条件:价格大于1000
  let(:smart_collection) { Factory :smart_collection_high_price, shop: shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  before :each do
    smart_collection
  end

  context '(match product)' do
    it "should be insert" do
      expect do
        iphone4
        iphone4.update_attribute :description, ''
      end.to change(SmartCollectionProduct, :count).by(1)
    end
  end

  context '(do not match product)' do
    it "should be ignore" do
      expect do
        psp
      end.to_not change(SmartCollectionProduct, :count)
    end

    it "should be delete" do
      iphone4
      expect do
        iphone4.update_attribute :price, 999
      end.to change(SmartCollectionProduct, :count).by(-1)
    end
  end

end
