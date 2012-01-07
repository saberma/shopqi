#encoding: utf-8
require 'spec_helper'

describe ProductVariantDrop do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:product_drop) { ProductDrop.new iphone4 }

  let(:variant_drop) { ProductVariantDrop.new iphone4.variants.first }

  it 'should get id' do
    variant_drop.id.should_not be_nil
  end

  it 'should get title' do
    variant_drop.title.should be nil
  end

  it 'should get price' do
    variant_drop.price.should eql 3000.0
  end

  it 'should get compare_at_price' do
    variant_drop.compare_at_price.should eql 3500.0
  end

  it 'should get available' do
    variant_drop.available.should be_true
  end

  it 'should get inventory_management' do
    variant_drop.inventory_management.should be_nil
  end

  it 'should get inventory_quantity' do
    variant_drop.inventory_quantity.should be_nil
  end

  it 'should get weight' do
    variant_drop.weight.should eql 2.9
  end

  it 'should get sku' do
    variant_drop.sku.should be_nil
  end

  it 'should get option1' do
    variant_drop.option1.should eql '默认标题'
  end

  it 'should get option2' do
    variant_drop.option2.should be_nil
  end

  it 'should get option3' do
    variant_drop.option3.should be_nil
  end

  it 'should get requires_shipping' do
    variant_drop.requires_shipping.should be_true
  end

end
