#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shippings", js: true do

  include_context 'login admin'

  before :each do
    visit shippings_path
  end

  describe "GET /admin/shipping" do

    describe Shipping do

      it "should be index" do # 显示列表
        page.should have_content('全国') # 默认记录
        page.should have_content('普通快递') # 默认记录
        page.should have_content('0kg - 25kg')
        page.should have_content('10元')
      end

      it "should be add" do # 新增
        click_on '新增目的地'
        within '#new-region' do
          select '广东省', form: 'province'
          select '深圳市', form: 'city'
          select '南山区', form: 'district'
          click_on '保存'
        end
        has_content?('新增成功!').should be_true
        within '#custom-shipping' do
          find(:xpath, './table[2]//th[1]').text.should eql '广东省深圳市南山区'
        end
      end

      it "should be destroy" do # 删除
        within '#custom-shipping' do
          within :xpath, './table[1]' do
            page.execute_script("window.confirm = function(msg) { return true; }")
            find('.del').click
          end
          page.should have_no_xpath('./table[1]')
        end
      end

    end

    describe "WeightBasedShippingRate" do
    end

  end

end
