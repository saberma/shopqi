# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Guides", js: true do

  include_context 'login admin'

  describe "GET /guides" do

=begin
    describe "Guide" do

      before(:each) do
        visit '/admin'
      end

      it "should be show" do
        has_content?('下一步骤: 商品').should be_true
      end

      it "should be guide" do
        guides = {
          '添加商品' => '点击此处增加一个商品',
          '定制外观' => '点击此处修改您的主题外观',
          '发布内容' => '点击此处修改您的商店内容',
          '支付网关' => '点击此处选择您的支付网关',
          '调整税率' => '点击此处设置您的税率',
          '物流配送' => '点击此处设置您的物流费用',
          '绑定域名' => '点击此处管理您的域名'
        }
        guides.each_pair do |guide, tip|
          find_link(guide).click
          find('.guide-outer').visible?.should be_true
          find('.guide-outer').has_content?(tip).should be_true
        end

      end

    end
=end

    describe "Task" do

      describe "Product" do

        before(:each) { visit '/admin/products' }

        it "should show check off" do
          has_content?('您的商店至少要有一个商品').should be_true
          find('#task-checkoff').visible?.should be_true
          find('#progress-bar').visible?.should be_false
        end

        it "should pick another" do
          click_on '选择其他步骤'
          sleep 3 # 等待opacity渲染
          click_on '添加商品'
          sleep 3
          find('#progress-bar').visible?.should be_false
        end

        it "should add product" do
          click_on '我已经完成此步骤'
          sleep 3 # 等待opacity渲染
          find('#task-checkoff').visible?.should be_false
          find('.guide-outer.above').visible?.should be_true
          find('.guide-outer.above').has_content?('下一步是 定制您的主题设置').should be_true
        end

      end

    end

  end

end
