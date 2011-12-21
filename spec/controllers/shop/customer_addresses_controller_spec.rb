#encoding: utf-8
require 'spec_helper'

describe Shop::CustomerAddressesController do
  include Devise::TestHelpers

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user_admin).shop
    model.update_attributes password_enabled: false
    model
  end

  let(:customer) { Factory(:customer_saberma, shop: shop) }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:customer] # http://j.mp/v4MP0i
    shop.themes.install theme_dark
    request.host = "#{shop.primary_domain.host}"
    sign_in(customer)
  end

  context 'exists custom customer template' do

    it 'should be use' do
      path = shop.theme.template_path('customers/addresses')
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'w') {|f| f.write('自定义内容') }
      get :index
      response.body.should include '自定义内容'
    end

  end

end
