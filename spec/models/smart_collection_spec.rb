#encoding: utf-8
require 'spec_helper'

describe SmartCollection do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { FactoryGirl.create :iphone4, shop: shop }

  let(:smart_collection) { FactoryGirl.create :smart_collection_default, shop: shop }

  context '#create' do

    context '(without handle)' do

      it 'should save handle' do
        collection = shop.smart_collections.create title: '热门商品'
        collection.handle.should eql 're-men-shang-pin'
      end
    end

    context '(with handle)' do

      it 'should save handle' do
        collection = shop.smart_collections.create title: '热门商品', handle: 'hot'
        collection.handle.should eql 'hot'
      end

    end

  end

  describe '#465' do

    context 'product destroyed' do

      before do
        iphone4
        smart_collection
      end

      describe 'collection_products' do

        it "should be destroy" do
          expect do
            iphone4.destroy
          end.to change(SmartCollectionProduct, :count).by(-1)
        end

      end

    end

  end

end
