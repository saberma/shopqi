# encoding: utf-8
require 'spec_helper'

describe Product do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop, product_type: '智能手机', vendor: 'Apple', tags_text: 'phone,phone,apple' }

  context '#create' do

    context '(without handle)' do

      it 'should save handle' do
        product = shop.products.create title: 'iphone 手机', product_type: '智能手机', vendor: 'Apple'
        product.handle.should eql 'iphone-shou-ji'
      end

      it 'should save unique handle' do
        shop.products.create title: 'iphone 手机', product_type: '智能手机', vendor: 'Apple'
        product = shop.products.create title: 'iphone 手机', product_type: '智能手机', vendor: 'Apple'
        product.handle.should eql 'iphone-shou-ji-1'
      end

    end

    context '(with handle)' do

      it 'should save handle' do
        product = shop.products.create title: 'iphone手机', handle: 'iphone', product_type: '手机', vendor: 'Apple'
        product.handle.should eql 'iphone'
      end

      it 'should save unique handle' do
        shop.products.create title: 'iphone手机', handle: 'iphone', product_type: '手机', vendor: 'Apple'
        product = shop.products.create title: 'iphone手机', handle: 'iphone', product_type: '手机', vendor: 'Apple'
        product.handle.should eql 'iphone-1'
      end

    end

  end

  describe 'Option' do

    it 'should be save' do
      iphone4.options.first.name.should eql '标题'
      iphone4.variants.first.option1.should eql '默认标题'
    end

    it 'should be ordered' do
      iphone4.options_attributes = [
        {name: '大小', value: '16G'},
        {name: '网络', value: 'WIFI'}
      ]
      iphone4.save
      iphone4.reload
      iphone4.options.map(&:name).should eql %w(标题 大小 网络)
      iphone4.options.map(&:position).should eql [1,2,3]
    end

    describe '#move' do

      it 'should be add' do
        iphone4.options_attributes = [
          {id: iphone4.options.first.id, _destroy: true},
          {name: '大小', value: '16G'},
          {name: '网络', value: 'WIFI'},
        ]
        iphone4.save
        iphone4.reload
        iphone4.options.map(&:name).should eql %w(大小 网络)
        iphone4.options.map(&:position).should eql [1,2]
        iphone4.variants.each do |variant|
          variant.option1.should eql '16G'
          variant.option2.should eql 'WIFI'
          variant.option3.should be_nil
        end
      end

      context '(with 3 options)' do

        before :each do
          iphone4.options_attributes = [
            {name: '大小', value: '16G'},
            {name: '网络', value: 'WIFI'},
          ]
          iphone4.save
          iphone4.reload # 注意要reload，使option的value重置为空
        end

        it 'at first' do
          iphone4.options_attributes = [
            {id: iphone4.options.first.id, _destroy: true}
          ]
          iphone4.save
          iphone4.reload
          iphone4.options.map(&:name).should eql %w(大小 网络)
          iphone4.options.map(&:position).should eql [1,2]
          iphone4.variants.each do |variant|
            variant.option1.should eql '16G'
            variant.option2.should eql 'WIFI'
          end
        end

        it 'at middle' do
          iphone4.options_attributes = [
            {id: iphone4.options.second.id, _destroy: true}
          ]
          iphone4.save
          iphone4.reload
          iphone4.options.map(&:name).should eql %w(标题 网络)
          iphone4.options.map(&:position).should eql [1,2]
          iphone4.variants.each do |variant|
            variant.option1.should eql '默认标题'
            variant.option2.should eql 'WIFI'
          end
        end

        it 'first two options' do
          iphone4.options_attributes = [
            {id: iphone4.options.first.id, _destroy: true},
            {id: iphone4.options.second.id, _destroy: true}
          ]
          iphone4.save
          iphone4.reload
          iphone4.options.map(&:name).should eql %w(网络)
          iphone4.options.map(&:position).should eql [1]
          iphone4.variants.each do |variant|
            variant.option1.should eql 'WIFI'
          end
        end

        it 'first and last options' do
          iphone4.options_attributes = [
            {id: iphone4.options.last.id, _destroy: true},
            {id: iphone4.options.first.id, _destroy: true}
          ]
          iphone4.save
          iphone4.reload
          iphone4.options.map(&:name).should eql %w(大小)
          iphone4.options.map(&:position).should eql [1]
          iphone4.variants.each do |variant|
            variant.option1.should eql '16G'
          end
        end

      end

    end

    it 'should be add' do
      iphone4.options_attributes = [
        {name: '大小', value: '默认大小'}
      ]
      iphone4.save
      iphone4.variants.first.option2.should eql '默认大小'
    end

    it 'should be destroy' do
      iphone4.options_attributes = [
        {name: '大小', value: '默认大小'}
      ]
      iphone4.save
      option = iphone4.options.second
      option.value.should eql '默认大小'
      iphone4.options_attributes = [
        {id: option.id, _destroy: true}
      ]
      iphone4.save
      iphone4.options.reject! {|option| option.destroyed?} #rails bug，使用_destroy标记删除后，需要reload后，删除集合中的元素才消失
      iphone4.options.size.should eql 1
    end

  end

  describe Tag do

    it 'should be save' do
      expect do
        iphone4
        Factory :iphone4, shop: shop, product_type: '智能手机', vendor: 'Apple', tags_text: 'phone,phone,apple'
      end.to change(Tag, :count).by(2)
    end

  end

end
