#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shops" do

  include_context 'login liwh'

  #设置的集成测试
  describe "GET /admin/general_preferences" do
    it "works!",js:true do
      visit admin_general_preferences_path
      fill_in 'shop[name]', with: '小商品店'
      fill_in 'shop[email]', with: 'liwh88@gmail.com'
      fill_in 'shop[address]', with: '世界之窗'
      fill_in 'shop[zip_code]', with: '444333'
      fill_in 'shop[phone]', with: '400-800-888-888'
      find_field('shop[password]').visible?.should be_false
      find_field('shop[password_message]').visible?.should be_false

      click_on '保存'
      find('#flashnotice').should have_content('修改成功!')
    end
  end
end
