# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Webhook", js: true do

  include_context 'login admin'

  let(:shop) { user_admin.shop }

  let(:webhook) { Factory(:webhook, shop: shop) }

  describe "GET /webhooks" do

    context 'with a webhook' do

      before(:each) do
        webhook
        visit notifications_path
      end

      it "should be index" do
        within '#webhooks-table > tbody' do
          within :xpath, './tr[2]' do
            find('td.event_name').text.should eql "订单发货"
            find('td.callback_url').text.should eql "http://express.shopqiapp.com"
          end
        end
      end

      it "should be destroy" do # 删除
        page.execute_script("window.confirm = function(msg) { return true; }")
        within '#webhooks-table > tbody' do
          page.should have_css('td.event_name')
          click_on '删除'
        end
        page.should have_content('删除成功!')
        within '#webhooks-table > tbody' do
          page.should have_no_css('td.event_name')
          page.should have_content('当前没有订阅任何事件')
        end
      end

    end

    describe 'add' do

      it "should be success" do
        visit notifications_path
        page.should have_content('当前没有订阅任何事件')
        click_on '新增事件回调'
        select '订单发货'
        fill_in 'webhook[callback_url]', with: 'http://express.shopqiapp.com'
        click_on '订阅'
        within '#webhooks-table > tbody' do
          within :xpath, './tr[2]' do
            find('td.event_name').text.should eql "订单发货"
            find('td.callback_url').text.should eql "http://express.shopqiapp.com"
          end
        end
        visit notifications_path # 回显
        within '#webhooks-table > tbody' do
          within :xpath, './tr[2]' do
            find('td.event_name').text.should eql "订单发货"
            find('td.callback_url').text.should eql "http://express.shopqiapp.com"
          end
        end
      end

    end

  end

end
