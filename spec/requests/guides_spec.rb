# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Guides", js: true do

  include_context 'login admin'

  let(:theme) { Factory :theme_woodland_dark }

  describe "Guide" do

    before(:each) do
      shop.themes.install theme
      visit '/admin'
    end

    it "should be show" do
      has_content?('下一步骤: 商品').should be_true
    end

    it "should be guide", focus: true do
      guides = {
        '添加商品' => '点击此处增加一个商品',
        '定制外观' => '点击此处修改您的主题外观',
        '发布内容' => '点击此处修改您的商店内容',
        '支付网关' => '点击此处选择您的支付网关',
        '物流配送' => '点击此处设置您的物流费用',
        '绑定域名' => '点击此处管理您的域名'
      }
      guides.each_pair do |guide, tip|
        find_link(guide).click
        find('.guide-outer').visible?.should be_true
        find('.guide-outer').should have_content(tip)
      end

    end

  end

  describe "Task" do

    describe "Product" do # 添加商品

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

      it "should be complete" do
        click_on '我已经完成此步骤'
        sleep 3 # 等待opacity渲染
        find('#task-checkoff').visible?.should be_false
        find('.guide-outer.above').visible?.should be_true
        find('.guide-outer.above').has_content?('下一步是 定制您的主题设置').should be_true
        visit '/admin' # 首页更新进度
        find('#next-step-description h2').text.should eql '下一步骤: 定制外观'
      end

    end

    describe "Theme" do # 定制外观

      before(:each) do
        shop.themes.install theme
        shop.tasks[0,1].map{|t| t.update_attributes completed: true}
        visit "/admin/themes/#{shop.theme.id}/settings"
      end

      it "should show check off" do
        has_content?('在此页面中修改您当前的主题').should be_true
        find('#task-checkoff').visible?.should be_true
        find('#progress-bar').visible?.should be_false
      end

      it "should pick another" do
        click_on '选择其他步骤'
        sleep 3 # 等待opacity渲染
        click_on '定制外观'
        sleep 3
        find('#progress-bar').visible?.should be_false
      end

      it "should be complete" do
        click_on '我已经完成此步骤'
        sleep 3 # 等待opacity渲染
        find('#task-checkoff').visible?.should be_false
        find('.guide-outer.above').visible?.should be_true
        find('.guide-outer.above').has_content?('下一步是 修改您的网页内容').should be_true
        visit '/admin' # 首页更新进度
        find('#next-step-description h2').text.should eql '下一步骤: 内容'
      end

    end

    describe "Page" do # 发布内容

      before(:each) do
        shop.tasks[0,2].map{|t| t.update_attributes completed: true}
        visit '/admin/pages'
      end

      it "should show check off" do
        has_content?('在此页面您可以为您的商店添加新的网页内容').should be_true
        find('#task-checkoff').visible?.should be_true
        find('#progress-bar').visible?.should be_false
      end

      it "should pick another" do
        click_on '选择其他步骤'
        sleep 3 # 等待opacity渲染
        click_on '发布内容'
        sleep 3
        find('#progress-bar').visible?.should be_false
      end

      it "should be complete" do
        click_on '我已经完成此步骤'
        sleep 3 # 等待opacity渲染
        find('#task-checkoff').visible?.should be_false
        find('.guide-outer.above').visible?.should be_true
        find('.guide-outer.above').has_content?('下一步是 设置您最常用的支付网关').should be_true
        visit '/admin' # 首页更新进度
        find('#next-step-description h2').text.should eql '下一步骤: 支付网关'
      end

    end

    describe "Payment" do # 支付网关

      before(:each) do
        shop.tasks[0,3].map{|t| t.update_attributes completed: true}
        visit '/admin/payments'
      end

      it "should show check off" do
        has_content?('支付网关用来从顾客那里接收货款').should be_true
        find('#task-checkoff').visible?.should be_true
        find('#progress-bar').visible?.should be_false
      end

      it "should pick another" do
        click_on '选择其他步骤'
        sleep 3 # 等待opacity渲染
        click_on '支付网关'
        sleep 3
        find('#progress-bar').visible?.should be_false
      end

      it "should be complete" do
        click_on '我已经完成此步骤'
        sleep 3 # 等待opacity渲染
        find('#task-checkoff').visible?.should be_false
        find('.guide-outer.above').visible?.should be_true
        find('.guide-outer.above').has_content?('下一步是 设置您的运费').should be_true
        visit '/admin' # 首页更新进度
        find('#next-step-description h2').text.should eql '下一步骤: 物流配送'
      end

    end

    describe "Shipping" do # 物流配送

      before(:each) do
        shop.tasks[0,4].map{|t| t.update_attributes completed: true}
        visit '/admin/shippings'
      end

      it "should show check off" do
        has_content?('在此页面您可以添加商品发送至任何地区的运费').should be_true
        find('#task-checkoff').visible?.should be_true
        find('#progress-bar').visible?.should be_false
      end

      it "should pick another" do
        click_on '选择其他步骤'
        sleep 3 # 等待opacity渲染
        click_on '物流配送'
        sleep 3
        find('#progress-bar').visible?.should be_false
      end

      it "should be complete" do
        click_on '我已经完成此步骤'
        sleep 3 # 等待opacity渲染
        find('#task-checkoff').visible?.should be_false
        find('.guide-outer.above').visible?.should be_true
        find('.guide-outer.above').has_content?('下一步是 绑定您的域名').should be_true
        visit '/admin' # 首页更新进度
        find('#next-step-description h2').text.should eql '下一步骤: 域名'
      end

    end

    describe "Domain" do # 绑定域名

      before(:each) do
        shop.tasks[0,5].map{|t| t.update_attributes completed: true}
        visit '/admin/domains'
      end

      it "should show check off" do
        has_content?('在此页面您可以为您的商店绑定其他域名').should be_true
        find('#task-checkoff').visible?.should be_true
        find('#progress-bar').visible?.should be_false
      end

      it "should pick another" do
        click_on '选择其他步骤'
        sleep 3 # 等待opacity渲染
        click_on '绑定域名'
        sleep 3
        find('#progress-bar').visible?.should be_false
      end

      it "should be complete" do
        click_on '我已经完成此步骤'
        has_content?('准备启用').should be_true # 跳转至后台管理首页
      end

    end

  end

  describe "Launch" do # 启用商店

    it "should be skip" do # 跳过指南，直接启用
      visit '/admin'
      page.execute_script("window.confirm = function(msg) { return true; }")
      click_on '跳过商店设置，直接启用商店'
      has_content?('您已经启用商店，恭喜您').should be_true
    end

    it "should be launch" do
      shop.tasks[0,6].map{|t| t.update_attributes completed: true}
      visit '/admin'
      click_on '启用我的商店'
      has_content?('您已经启用商店，恭喜您').should be_true
      visit '/admin' # 再次访问后台管理，不再显示启用提示
      has_content?('您已经启用商店，恭喜您').should be_false
    end

  end

  describe "payment tip" do # 支付网关提示

    before(:each) { shop.launch! }

    context 'without payment' do # 未设置任何支付网关

      it "should be show" do
        visit '/admin'
        has_css?('#account-status').should be_true
        find('#account-status').has_content?('选择一个支付网关').should be_true
      end

    end

    context 'with payment' do # 已设置支付网关

      it "should be hide" do
        shop.payments.create message: '汇款至:...', name: '邮政汇款'
        visit '/admin'
        has_css?('#account-status').should be_false
      end

    end

  end

end
