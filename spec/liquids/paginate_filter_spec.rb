# encoding: utf-8
require 'spec_helper'

describe PaginateFilter do

  let(:shop) { Factory(:user).shop }

  let(:collection) { CustomCollection.new(title: '所有商品', products: shop.products) }

  let(:collection_drop) { CollectionDrop.new(collection) }

  context '#default_pagination' do

    it 'should get page html' do
      variant = "{% paginate collection.products by 1 %}{{ paginate | default_pagination }}{% endpaginate %}"
      assign = { 'collection' => collection_drop, 'current_page' => '5' }
      result = %q( <span class="prev"><a href="?page=4">« Previous</a></span> <span class="page"><a href="?page=1">1</a></span> <span class="deco">...</span> <span class="page"><a href="?page=3">3</a></span> <span class="page"><a href="?page=4">4</a></span> <span class="page current">5</span> <span class="page"><a href="?page=6">6</a></span> <span class="next"><a href="?page=6">Next »</a></span>)
      Liquid::Template.parse(variant).render(assign).should eql result
    end

    it 'should get empty while over page' do #无效当前页
      variant = "{% paginate collection.products by 2 %}{{ paginate | default_pagination }}{% endpaginate %}"
      assign = { 'collection' => collection_drop, 'current_page' => '5' }
      result = ''
      Liquid::Template.parse(variant).render(assign).should eql result
    end

  end

end
