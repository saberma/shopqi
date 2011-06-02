require 'spec_helper'

describe BaseFilter do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:product_drop) { ProductDrop.new iphone4 }

  context '#json' do

    it 'should get product' do
      variant = "{{ product | json }}"
      assign = { product: product_drop }
      Liquid::Template.parse(variant).render(assign).should_not be_empty
    end

  end

end
