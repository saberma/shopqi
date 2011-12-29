#encoding: utf-8
require 'spec_helper'

describe SearchDrop do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:search_drop) { SearchDrop.new([iphone4], 'iphone') }

  it 'should get terms' do
    variant = "{{ search.terms }}"
    liquid(variant).should eql "iphone"
  end

  it 'should get performed' do
    variant = "{{ search.performed }}"
    liquid(variant).should eql "true"
  end

  it 'should get results' do
    variant = "{{ search.results | size }}"
    liquid(variant).should eql "1"
  end

  it 'should get results count', f: true do
    variant = "{{ search.results_count }}"
    liquid(variant).should eql "1"
  end

  describe SearchItemDrop do

    it 'should get url' do
      variant = "{% for item in search.results %}{{ item.url }}{% endfor %}"
      result = "/products/#{iphone4.handle}"
      liquid(variant).should eql result
    end

    it 'should get title' do
      variant = "{% for item in search.results %}{{ item.title }}{% endfor %}"
      result = iphone4.title
      liquid(variant).should eql result
    end

    it 'should get content' do
      variant = "{% for item in search.results %}{{ item.content }}{% endfor %}"
      result = iphone4.body_html
      liquid(variant).should eql result
    end

    it 'should get featured_image', focus: true do
      photo = iphone4.photos.build
      photo.product_image = Rails.root.join('app/assets/images/avatar.jpg')
      photo.save!
      variant = "{% for item in search.results %}{{ item.featured_image | product_img_url: 'thumb' }}{% endfor %}"
      liquid(variant).should eql iphone4.index_photo
    end

  end

  private
  def liquid(variant, assign = {'search' => search_drop})
    Liquid::Template.parse(variant).render(assign)
  end

end
