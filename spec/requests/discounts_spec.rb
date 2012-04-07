# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Discounts", js: true do

  include_context 'login admin'

  let(:shop) { user_admin.shop }

  describe "GET /discounts" do

    context 'exist discount' do

      let(:discount) { shop.discounts.create code: 'COUPON123', value: 10, usage_limit: 20 }

      before(:each) do
        discount
        visit discounts_path
      end

      it "should be index" do
        within '#coupons > tbody' do
          within :xpath, './tr[2]' do
            find('.coupon').text.should eql discount.code
            find('td.value').text.should eql "10"
            find('td.note').text.should eql "已使用 0 次\n剩余 20 次"
          end
        end
      end

      it "should be destroy" do # 删除
        page.execute_script("window.confirm = function(msg) { return true; }")
        within '#coupons > tbody' do
          click_on '删除'
        end
        page.should have_content('删除成功!')
        within '#coupons > tbody' do
          page.should have_no_xpath('./tr[2]')
        end
      end

    end

    describe 'add' do

      it "should be success" do
        visit discounts_path
        click_on '新增优惠码'
        within '#new-code' do
          fill_in 'discount[code]', with: 'COUPON123'
          fill_in 'discount[value]', with: '10'
          fill_in 'discount[usage_limit]', with: '20'
          click_on '新增优惠码'
        end
        within '#coupons > tbody' do
          within :xpath, './tr[2]' do
            find('.coupon').text.should eql 'COUPON123'
            find('td.value').text.should eql '10'
            find('td.note').text.should eql "已使用 0 次\n剩余 20 次"
          end
        end
        visit discounts_path # 回显
        within '#coupons > tbody' do
          within :xpath, './tr[2]' do
            find('.coupon').text.should eql 'COUPON123'
            find('td.value').text.should eql '10'
            find('td.note').text.should eql "已使用 0 次\n剩余 20 次"
          end
        end
      end

    end

  end

end
