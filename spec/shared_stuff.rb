# encoding: utf-8
require 'subdomain_capybara_server'

shared_context 'login admin' do
  let(:user_admin) { Factory :user_admin }

  let(:shop) { user_admin.shop }

  before :each do
    Capybara::Server.manual_host = shop.primary_domain.host
    visit new_user_session_path
    fill_in 'user[email]', with: user_admin.email
    fill_in 'user[password]', with: user_admin.password
    click_on '登录'
  end

  after(:each) { Capybara::Server.manual_host = nil }
end

shared_context 'use shop' do # 访问 shopqi.com

  let(:theme) { Factory :theme_woodland_dark }

  let(:user_admin) {  Factory :user_admin }

  let(:shop) do
    model = user_admin.shop
    model.update_attributes password_enabled: false
    model.themes.install theme
    model
  end

  before :each do
    Capybara::Server.manual_host = shop.primary_domain.host
  end

  after(:each) { Capybara::Server.manual_host = nil }
end

shared_context 'use shopqi host' do # 访问 shopqi.com
  before :each do
    Capybara::Server.manual_host = Setting.host
  end

  after(:each) { Capybara::Server.manual_host = nil }
end

shared_examples "api_examples_index" do
  before(:each) do
    request.host = "#{shop.primary_domain.host}"
    session[:shop] = shop.to_json
  end

  it "should get #index" do
    get :index, format: :json
    response.should be_success
  end

end
