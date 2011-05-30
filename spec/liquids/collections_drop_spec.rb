#encoding: utf-8
require 'spec_helper'

describe CollectionsDrop do

  let(:shop) { Factory(:user).shop }

  it 'should get frontpage' do
    variant = "{% for product in collections.frontpage.products %}<span>{{ product.title }}</span>{% endfor %}"
    result = "<span>示例商品1</span><span>示例商品2</span><span>示例商品3</span><span>示例商品4</span><span>示例商品5</span><span>示例商品6</span>"
    Liquid::Template.parse(variant).render('collections' => CollectionsDrop.new(shop)).should eql result
  end

end
