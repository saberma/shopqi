#encoding: utf-8
require 'spec_helper'

describe SmartCollection do

  let(:shop) { Factory(:user).shop }

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

end
