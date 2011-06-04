#encoding: utf-8
require 'spec_helper'

describe CustomCollection do

  let(:shop) { Factory(:user).shop }

  before :each do
    # 删除默认记录，方便测试
    shop.custom_collections.clear
    shop.reload
  end

  context '#create' do

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

end
