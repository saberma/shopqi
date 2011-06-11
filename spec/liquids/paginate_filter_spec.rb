# encoding: utf-8
require 'spec_helper'

describe PaginateFilter do

  let(:shop) { Factory(:user).shop }

  let(:collection) { CustomCollection.new(title: '所有商品', products: shop.products) }

  let(:collection_drop) { CollectionDrop.new(collection) }

  it 'should get default_pagination' do
    variant = "{% paginate collection.products by 2 %}{{ paginate | default_pagination }}{% endpaginate %}"
    assign = { 'collection' => collection_drop }
    result = %q( <span class="page current">1</span> <span class="page"><a href="?page=2">2</a></span> <span class="page"><a href="?page=3">3</a></span> <span class="next"><a href="?page=2">Next »</a></span>)
    Liquid::Template.parse(variant).render(assign).should eql result
  end

end
