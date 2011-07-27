require 'spec_helper'

describe Shop::ShopsController do

  let(:shop) { Factory(:user_admin).shop }

  let(:iphone4) { Factory.build(:iphone4) }

  before :each do
    shop.theme.switch Theme.find_by_name('Prettify')
    request.host = "#{shop.primary_domain.url}"
  end

  it 'should be show' do
    get :show
    response.should be_success
  end

  it 'should get css file' do
    get :asset, id: shop.id, file: 'style', format: 'css'
    response.should be_success
  end

end
