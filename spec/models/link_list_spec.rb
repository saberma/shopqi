# encoding: utf-8
require 'spec_helper'

describe LinkList do

  let(:shop) { Factory(:user).shop }

  let(:link_list) { Factory :link_list, shop: shop }

  let(:iphone4) { Factory :iphone4, shop: shop, product_type: '智能手机', vendor: 'Apple', tags_text: 'phone,phone,apple' }

  let(:collection) { Factory :custom_collection, shop: shop }

  let(:about_us) { Factory 'about-us', shop: shop }

  let(:welcome) { Factory :welcome, shop: shop }

  describe Link do

    context '(blog)' do

      it 'should get url' do
        link = link_list.links.build title: '博客', link_type: 'blog', subject_handle: welcome.id.to_s
        link.url.should eql "/blogs/#{welcome.handle}"
      end

    end

    context '(frontpage)' do

      it 'should get url' do
        link = link_list.links.build title: '首页', link_type: 'frontpage'
        link.url.should eql '/'
      end

    end

    context '(collection)' do

      it 'should get url' do
        link = link_list.links.build title: '商品列表', link_type: 'collection', subject_handle: collection.id.to_s
        link.url.should eql "/collections/#{collection.handle}"
      end

    end

    context '(page)' do

      it 'should get url' do
        link = link_list.links.build title: '关于我们', link_type: 'page', subject_handle: about_us.id.to_s
        link.url.should eql "/pages/#{about_us.handle}"
      end

    end

    context '(product)' do

      it 'should get url' do
        link = link_list.links.build title: 'iphone', link_type: 'product', subject_handle: iphone4.id.to_s
        link.url.should eql "/products/#{iphone4.handle}"
      end

    end

    context '(search)' do

      it 'should get url' do
        link = link_list.links.build title: '查询', link_type: 'search'
        link.url.should eql "/search"
      end

    end

    context '(http)' do

      it 'should get url' do
        link = link_list.links.build title: '其他', link_type: 'http', subject: 'http://shopqi.com'
        link.url.should eql "http://shopqi.com"
      end

    end

  end

end
