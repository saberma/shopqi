#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shippings" do
  include_context 'login admin'
  describe "GET /admin/shipping/index" do
    it "works! ", js: true do
      visit shipping_index_path
      click_on '增加'
      select '中国', from: 'country_code'
      click_on '保存'
      page.should have_content('新增成功')

      visit shipping_index_path
      page.should have_content('中国')
      find_field('weight_based_shipping_rate[name]').visible?.should be_false
      find_field('weight_based_shipping_rate[weight_low]').visible?.should be_false
      find_field('weight_based_shipping_rate[weight_high]').visible?.should be_false

      find_field('price_based_shipping_rate[name]').visible?.should be_false
      find_field('price_based_shipping_rate[min_order_subtotal]').visible?.should be_false
      find_field('price_based_shipping_rate[max_order_subtotal]').visible?.should be_false
    end
  end
end
