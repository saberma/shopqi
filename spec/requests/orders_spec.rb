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

  let(:payment_alipay) do # 支付方式:支付宝
    Factory :payment_alipay, shop: shop
  end

  let(:order) do
    o = Factory.build :order, shop: shop, shipping_rate: '普通快递-10.0', payment_id: payment_alipay.id
    o.line_items.build [
      {product_variant: iphone4_variant, price: 10, quantity: 2},
      {product_variant: psp_variant, price: 20, quantity: 2},
    ]
    o.save
    o
  end

  ##### 查看 #####
  describe "GET /orders/id" do

    context "#pending" do

      before :each do
        order.financial_status = :pending # 假设顾客已经提交订单
        order.save
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
          select '其它', from: 'shipping_options[manual][tracking_company]'
          click_on '发货'
        end
        within '#unshipped-goods' do
          has_content?('完成发货').should be_true
          has_content?('此订单的所有商品已经发货').should be_true
        end
      end

      it "should accept payment" do
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
            end
            find('.line-price').text.should eql '10'
            find('.line-qty').text.should eql '2'
            find('.total-col').text.should eql '20'
          end
          within(:xpath, ".//tr[2]") do
            within(:xpath, ".//td[2]") do
              has_content?(psp.title).should be_true
            end
            find('.line-price').text.should eql '20'
            find('.line-qty').text.should eql '2'
            find('.total-col').text.should eql '40'
          end
        end
        within '#price-summary' do
          find('.subtotal').text.should eql '60'
          find('.totalnum.total-col').text.should eql '70'
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

      it "should list other orders" do # 此顾客的其他待处理的订单
        o = Factory.build :order, shop: shop, shipping_rate: '普通快递-10.0', payment_id: payment_alipay.id
        o.line_items.build [ {product_variant: iphone4_variant, price: 10, quantity: 2}, ]
        o.save
        visit order_path(order)

        within '#other-orders' do
          has_content?(o.name).should be_true
          has_content?(o.created_at.to_s(:short)).should be_true
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

    context "product do not requires shipping" do # 虚拟商品不需要收货地址

      let(:order) do
        o = Factory.build :order_not_requires_shipping, shop: shop, payment_id: payment_alipay.id
        o.line_items.build [ {product_variant: iphone4_variant, price: 10, quantity: 2}, ]
        o.save
        o
      end

      before do
        iphone4_variant.update_attributes! requires_shipping: false
      end

      it "should be show" do
        visit order_path(order)
        has_content?(order.name).should be_true
        find('#shipping-address').should have_content('此商品不需要收货地址') # 收货地址
        find('#order-fulfillment').should have_content('不需要配送') # 配送方式
      end

    end

  end

  ##### 列表 #####
  describe "GET /orders" do

    context "(with a order)" do

      it "should be list" do
        visit orders_path
        has_content?(order.name).should be_true
      end

    end

  end

end
