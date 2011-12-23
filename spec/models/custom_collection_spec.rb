#encoding: utf-8
require 'spec_helper'

describe CustomCollection do

  let(:shop) { Factory(:user).shop }

  context '#create' do

    before :each do
      # 删除默认记录，方便测试
      shop.custom_collections.clear
      shop.reload
    end

    context '(without handle)' do

      it 'should save handle' do
        collection = shop.custom_collections.create title: '热门商品'
        collection.handle.should eql 're-men-shang-pin'
      end
    end

    context '(with handle)' do

      it 'should save handle' do
        collection = shop.custom_collections.create title: '热门商品', handle: 'hot'
        collection.handle.should eql 'hot'
      end

    end

  end

  describe CustomCollectionProduct do

    let(:frontpage_collection) { shop.custom_collections.where(handle: 'frontpage').first }

    let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

    context 'create' do

      it 'should init position' do
        iphone4
        frontpage_collection.reload.collection_products.first.position.should_not be_nil
      end

    end

  end

end
