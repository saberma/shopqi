#encoding: utf-8
require 'spec_helper'

describe ProductDrop do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:product_drop) { ProductDrop.new iphone4 }

  it 'should get url' do
    variant = "{{ product.url }}"
    liquid(variant).should eql "/products/#{iphone4.handle}"
  end

  it 'should get title' do
    variant = "{{ product.title }}"
    liquid(variant).should eql "iphone4"
  end

  it 'should get price' do
    variant = "{{ product.price }}"
    liquid(variant).should eql "3000.0"
  end

  it 'should get description' do
    variant = "{{ product.description }}"
    liquid(variant).should eql iphone4.body_html
  end

  it 'should get available' do
    variant = "{{ product.available }}"
    liquid(variant).should eql 'true'
  end

  it 'should get variants' do
    variant = "{{ product.variants | size }}"
    liquid(variant).should eql '1'
  end

  it 'should get options' do
    variant = "{{ product.options | size }}"
    liquid(variant).should eql '1'
  end

  describe ProductImageDrop do

    before(:each) do
      photo = iphone4.photos.build
      photo.product_image = Rails.root.join('spec/factories/data/products/iphone4.jpg')
      photo.save!
    end

    it 'should get images' do
      variant = "{{ product.images | size }}"
      liquid(variant).should eql '1'
    end

    it 'should get featured_image', focus: true do
      variant = "{{ product.featured_image | product_img_url: 'thumb' }}"
      liquid(variant).should eql iphone4.index_photo
    end

  end

  describe ProductOptionDrop do

    it 'should get json' do
      result = '标题'
      product_drop.options.first.as_json.should eql result
    end

    it 'should get label' do
      result = '标题'
      variant = "{{ product.options.first }}"
      liquid(variant).should eql result
    end

  end

  describe 'compare_at_price' do

    it 'should get max' do
      result = '3500.0'
      variant = "{{ product.compare_at_price_max }}"
      liquid(variant).should eql result
    end

    it 'should get min' do
      result = '3500.0'
      variant = "{{ product.compare_at_price_min }}"
      liquid(variant).should eql result
    end

  end

  private
  def liquid(variant, assign = {'product' => product_drop})
    Liquid::Template.parse(variant).render(assign)
  end

end
