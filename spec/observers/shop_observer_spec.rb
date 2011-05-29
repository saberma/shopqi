require 'spec_helper'

describe ShopObserver do

  let(:shop) { Factory(:user).shop }

  context '#create' do

    it "should save link list" do
      expect do
        expect do
          shop
        end.to change(LinkList, :count).by(2)
      end.to change(Link, :count).by(5)
    end

    it "should save page" do
      expect do
        shop
      end.to change(Page, :count).by(2)
    end

    it "should save collection and products" do
      expect do
        expect do
          shop
        end.to change(CustomCollection, :count).by(1)
      end.to change(Product, :count).by(6)
    end

  end
  
end
