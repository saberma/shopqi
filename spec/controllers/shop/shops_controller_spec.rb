require 'spec_helper'

describe Shop::ShopsController do

  let(:shop) { Factory(:user_admin).shop }

  let(:iphone4) { Factory.build(:iphone4) }

  before :each do
    shop.theme.switch Theme.find_by_name('Prettify')
    request.host = "#{shop.primary_domain.host}"
  end

  context '#password_protected' do

    it 'should be show' do
      session = mock('session')
      session.stub!(:[], 'storefront_digest').and_return(true)
      controller.stub!(:session).and_return(session)
      controller.stub!(:cart_drop).and_return({}) # 特殊处理，session.stub!(:[], 'cart')会覆盖storefront_digest
      get :show
      response.should be_success
    end

    it 'should be redirect' do
      get :show
      response.should be_redirect
    end

  end

  context '#without password_protected' do

    before :each do
      shop.update_attributes password_enabled: false
    end

    it 'should be show' do
      get :show
      response.should be_success
    end

    it 'should get css file' do
      get :asset, id: shop.id, theme_id: shop.theme.id, file: 'style', format: 'css'
      response.should be_success
    end

  end

end
