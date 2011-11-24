#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'
require 'resque_spec/scheduler'

describe "Account" do

  context '#destroy' do #删除商店
    describe "GET /admin/account" do
      include_context 'login admin'

      it "works", js: true do
        visit account_index_path
        click_on '删除我的帐户(我知道这是无法恢复的)'
        page.should have_content('关闭商店')

        page.execute_script("window.confirm = function(msg) { return true; }")
        select '很难使用', form: "cancel_reason_selection"
        fill_in "cancel_reason[detailed]", with: "测试删除"
        click_on "关闭商店"

        page.should have_content('成功删除')
        DeleteShop.should have_scheduled(Shop.first.id)
      end
    end
  end
end
