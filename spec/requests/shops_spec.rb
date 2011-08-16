#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shops" do

  include_context 'login admin'

  describe "GET /admin/general_preferences" do #设置的集成测试

    it "works!",js:true do
      visit general_preferences_path
      fill_in 'shop[name]', with: '小商品店'
      fill_in 'shop[email]', with: 'liwh88@gmail.com'
      fill_in 'shop[address]', with: '世界之窗'
      fill_in 'shop[zip_code]', with: '444333'
      fill_in 'shop[phone]', with: '400-800-888-888'
      find_field('shop[password]').visible?.should be_true # 未启用商店前默认有密码保护
      find_field('shop[password_message]').visible?.should be_true

      click_on '保存'
      page.should have_content('修改成功!')
    end

  end

end
