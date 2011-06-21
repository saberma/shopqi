# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Orders", js: true do

  include_context 'login admin'

  let(:shop) { user_admin.shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  let(:iphone4_variant) { iphone4.variants.first }

  let(:psp_variant) { psp.variants.first }

  let(:order) do
    o = Factory.build(:order, shop: shop)
    o.line_items.build [
      {product_variant: iphone4_variant, price: 10, quantity: 2},
      {product_variant: psp_variant, price: 20, quantity: 2},
    ]
    o.save
    o
  end

  before :each do
    order
  end

  ##### 查看 #####
  describe "GET /orders/id" do

    context "#pending" do

      before :each do
        order.update_attribute :financial_status, :pending # 假设顾客已经提交订单
      end

      it "should list products" do
        visit order_path(order)
        within '#line-items' do
          #within(:xpath, "//tbody[@id='line-items']//tr[1]") do
          within(:xpath, ".//tr[1]") do
            within(:xpath, ".//td[2]") do
              has_content?(iphone4.title).should be_true
              has_content?(iphone4_variant.option1).should be_true
            end
            find('.line-price').text.should eql '10'
            find('.line-qty').text.should eql '2'
            find('.total-col').text.should eql '20'
          end
          within(:xpath, ".//tr[2]") do
            within(:xpath, ".//td[2]") do
              has_content?(psp.title).should be_true
              has_content?(psp_variant.option1).should be_true
            end
            find('.line-price').text.should eql '20'
            find('.line-qty').text.should eql '2'
            find('.total-col').text.should eql '40'
          end
        end
        within '#price-summary' do
          find('.subtotal').text.should eql '60'
          find('.totalnum.total-col').text.should eql '60'
        end
      end

      it "should list address" do
        visit order_path(order)

        within '#ship-addr' do
          has_content?('13928452888').should be_true
          has_content?('马海波').should be_true
          has_content?('广东省').should be_true
          has_content?('深圳市').should be_true
          has_content?('南山区').should be_true
        end

        within '#bill-addr' do
          has_content?('13928452888').should be_true
          has_content?('马海波').should be_true
          has_content?('广东省').should be_true
          has_content?('深圳市').should be_true
          has_content?('南山区').should be_true
        end
      end

      it "should list histories" do
        visit order_path(order)
        within '#order-history' do
          has_content?('创建订单').should be_true
        end
      end

      it "should save note" do
        visit order_path(order)
        find('#order-note').visible?.should be_false
        click_on '备注'
        within '#note-form' do
          fill_in 'order[note]', with: '顾客要求尽快发货'
        end
        click_on '保存备注'
        find('#order-note').visible?.should be_true
        find('#note-body').text.should eql '顾客要求尽快发货'
        visit order_path(order)
        has_content?('顾客要求尽快发货').should be_true
      end

      it "should be close" do
        visit order_path(order)
        click_on '关闭此订单' #跳转至订单列表
        has_content?(order.title).should be_false

        click_on '正常'
        click_on '已关闭'
        has_content?(order.title).should be_true
      end

    end

    context "#abandoned" do

      it "should show tip" do
        visit order_path(order)
        has_content?('此订单已经被放弃').should be_true
        find('.warn').visible?.should be_true
      end

      it "should not show cancel action" do
        visit order_path(order)
        has_content?('取消此订单').should be_false
      end

      it "should not list abandoned order" do
      end

    end

  end

  ##### 列表 #####
  describe "GET /orders" do

    context "(with a order)" do

      it "should not list abandoned order" do
        visit orders_path
        has_content?(order.name).should be_false # 默认不显示[放弃]的订单

        click_on '任何支付状态'
        click_on '放弃'
        has_content?(order.name).should be_true

        order.update_attribute :financial_status, :pending # 假设顾客已经提交订单
        visit orders_path
        has_content?(order.name).should be_true
      end

    end

  end

end
