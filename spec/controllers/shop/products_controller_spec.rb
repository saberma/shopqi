require 'spec_helper'

describe Shop::ProductsController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user_admin).shop
    model.themes.install theme
    model.update_attributes password_enabled: false
    model
  end

  let(:iphone4) { Factory(:iphone4, shop: shop) }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  it 'should be show' do
    get 'show', handle: iphone4.handle
    response.should be_success
    response.body.should have_content('iphone')
  end

end
