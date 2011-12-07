#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Permission", js: true do # 权限

  context 'User' do # 用户

    context 'is admin' do # 为管理员

      context 'get /admin' do # 在后台管理
        include_context 'login admin'

        describe '#menu' do #菜单

          let(:iphone4) { Factory :iphone4, shop: shop }

          let(:iphone4_variant) { iphone4.variants.first }

          let(:order) do
            o = Factory.build(:order, shop: shop)
            o.line_items.build [ {product_variant: iphone4_variant, price: 10, quantity: 2}, ]
            o.financial_status = :pending # 假设顾客已经提交订单
            o.save
            o
          end

          describe "order" do # 订单

            before { order }

            it "should be active" do # 显示为有权限
              visit user_root_path
              find(:xpath, "//ul[@id='navlist']//a[text()='订单 (1)']")['class'].should_not include 'inactive'
            end

          end

          describe "customer" do # 顾客

            it "should be active" do # 显示为有权限
              find(:xpath, "//ul[@id='navlist']//a[text()='顾客']")['class'].should_not include 'inactive'
            end

          end

        end

      end

    end

  end

end
