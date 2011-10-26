#encoding: utf-8
require 'spec_helper'

describe BaseFilter do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:product_drop) { ProductDrop.new iphone4 }

  context '#json' do

    it 'should get product' do
      variant = "{{ product | json }}"
      assign = { 'product' => product_drop }
      json_text = Liquid::Template.parse(variant).render(assign)
      json_text.should_not include 'Liquid error'
      json = JSON(json_text)
      json.should_not be_empty
      json['title'].should eql iphone4.title
      json['handle'].should eql iphone4.handle
      json['options'].should eql ['标题']
      variant = iphone4.variants.first
      json['variants'].should eql [
        {
          'id' => variant.id,
          'option1' => '默认标题',
          'option2' => nil,
          'option3' => nil,
          'title' => '默认标题',
          'price' => variant.price,
          'compare_at_price' => variant.compare_at_price,
          'weight' => variant.weight,
          'sku' => variant.sku
        },
      ]
    end

  end

end
