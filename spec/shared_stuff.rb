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
