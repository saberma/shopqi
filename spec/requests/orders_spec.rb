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

  let(:payment_alipay) do # 支付方式:支付宝
    Factory :payment_alipay, shop: shop
  end

  before :each do
    order
  end

  ##### 查看 #####
  describe "GET /orders/id" do

    context "#abandoned" do

      it "should show tip" do
        visit order_path(order)
        has_content?('此订单已经被放弃').should be_true
      end

      it "should not show cancel action" do
        visit order_path(order)
        within '#action-links' do
          has_content?('取消此订单').should be_false
        end
      end

      it "should not list abandoned order" do
        visit orders_path
        has_content?(order.name).should be_false
      end

    end

    context "#pending" do

      before :each do
        order.update_attribute :financial_status, :pending # 假设顾客已经提交订单
      end

      it "should save fulfillment" do #支持分批发货
        visit order_path(order)
        click_on '发货'
        within '#unshipped-goods' do
          has_content?('您需要准备 2 款商品').should be_true
        end
        within '#batch_fulfillment_form' do # 先发一个商品
          uncheck 'line-item-2'
          fill_in 'shipping_options[manual][tracking_number]', with: '123456'
          select 'EMS', from: 'shipping_options[manual][tracking_company]'
          click_on '发货'
        end
        within '#unshipped-goods' do
          find_button('发货').visible?.should be_true
          has_content?('您需要准备 1 款商品').should be_true
        end
        visit order_path(order) #回显,订单历史
        within '#order-history' do
          click_on '我们已经将1个商品发货' #更新快递单号
          fill_in 'tracking_number', with: 'E45'
          select 'EMS', from: 'tracking_company'
          click_on '更新'
        end
        click_on '发货' #发第二个商品
        within '#batch_fulfillment_form' do
          fill_in 'shipping_options[manual][tracking_number]', with: '789012'
          select '其他', from: 'shipping_options[manual][tracking_company]'
          click_on '发货'
        end
        within '#unshipped-goods' do
          has_content?('完成发货').should be_true
          has_content?('此订单的所有商品已经发货').should be_true
        end
      end

      it "should accept payment" do
        order.financial_status = 'pending'
        order.payment = payment_alipay
        order.save
        visit order_path(order)
        within '#order-status' do
          page.should have_content('在线支付-支付宝')
        end
        click_on '已收到款项'
        within '#order-status' do
          has_content?('已支付').should be_true
        end
        visit order_path(order) #回显
        within '#order-status' do
          has_content?('已支付').should be_true
        end
        within '#order-history' do
          has_content?('我们已经成功接收款项').should be_true
        end
        visit orders_path #列表显示状态
        within(:xpath, "//table[@id='order-table']/tbody/tr[1]") do
          has_content?('已支付').should be_true
        end
      end

      it "should list products" do
        visit order_path(order)
        within '#line-items' do
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
        sleep 3 # 延时处理
        find('#order-note').visible?.should be_true
        find('#note-body').text.should eql '顾客要求尽快发货'
        visit order_path(order)
        has_content?('顾客要求尽快发货').should be_true
      end

      it "should be close" do
        visit order_path(order)
        click_on '关闭此订单' #跳转至订单列表
        has_content?(order.name).should be_false

        click_on '正常'
        click_on '已关闭'
        has_content?(order.name).should be_true

        click_on order.name
        find('.warn').visible?.should be_true #显示关闭的提示
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
