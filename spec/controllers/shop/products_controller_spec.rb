require 'spec_helper'

describe Shop::ProductsController do

  let(:shop) { Factory(:user_admin).shop }

  let(:iphone4) { Factory(:iphone4, shop: shop) }

  before :each do
    request.host = "#{shop.primary_domain.url}"
  end

  it 'should be show' do
    get 'show', handle: iphone4.handle
    response.should be_success
    response.body.should have_content('iphone')
  end

end
