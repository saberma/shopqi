require 'spec_helper'

describe Shop::CartController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  before :each do
    shop.themes.install theme
    request.host = "#{shop.primary_domain.host}"
  end

  context 'exists variant' do

    before :each do
      session = mock('session')
      session.stub!(:[], 'cart').and_return("#{variant.id}|1")
      session.stub!(:[]=)
      controller.stub!(:session).and_return(session)
    end

    it 'should be update' do
      post :update, shop_id: shop.id, updates: [1]
      response.should be_redirect
    end

    it 'should be change' do # 一般用于删除
      get :change, variant_id: variant.id, quantity: 0
      response.should be_redirect
    end

    context '#checkout' do # 结算

      it 'should be submit by button' do
        expect do
          post :update, shop_id: shop.id, updates: {}, checkout: :checkout
        end.should change(Cart, :count).by(1)
      end

      it 'should be submit by image', focus: true do
        expect do
          post :update, shop_id: shop.id, updates: {}, 'checkout.x' => 88
        end.should change(Cart, :count).by(1)
      end

    end

  end

  context 'missing variant' do # 款式已在后台管理中删除

    let(:un_exist_variant_id) { 8888 }

    before :each do
      session = mock('session')
      session.stub!(:[], 'cart').and_return("#{un_exist_variant_id}|1")
      session.stub!(:[]=)
      controller.stub!(:session).and_return(session)
    end

    it 'should not be show' do
      get :show
      response.body.should_not include "Liquid error: Couldn't find ProductVariant with id=#{un_exist_variant_id}"
    end

  end

end
