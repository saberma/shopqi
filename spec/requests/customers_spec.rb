# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Customers", js: true do

  include_context 'login admin'

  let(:shop) { user_admin.shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:iphone4_variant) { iphone4.variants.first }

  let(:order) do
    o = Factory.build(:order, shop: shop)
    o.line_items.build [
      {product_variant: iphone4_variant, price: 10, quantity: 2},
    ]
    o.financial_status = :pending
    o.save
    o
  end

  ##### 列表 #####
  describe "GET /customers" do

    before :each do
      order
    end

    describe 'Group' do

      # 显示当前查询分组
      it "should show current search" do
        visit customers_path
        find('#customer-search_field').click # 一点击查询输入框才会显示过滤器
        fill_in_blur 'customer-search_field', with: '马海波'
        select '订单数'
        select '小于'
        fill_in 'filter-value', with: '10'
        click_on '新增过滤器'
        within '#customer-groups' do
          find(:xpath, './li[2]').visible?.should be_true
          within :xpath, './li[2]' do
            has_content?('当前查询').should be_true
            sleep 10
            find(:xpath, './ul/li[1]').text.should eql '关键字:马海波'
            find(:xpath, './ul/li[2]').text.should eql '订单数 小于 10'
          end
        end
      end

      # 显示分组查询条件
      it "should be show" do
        visit customers_path
        within '#customer-groups' do
          find(:xpath, './li[3]').click # 接收营销邮件
        end
        within '#customer-search_filters' do
          find(:xpath, "//div[contains(@class, 'filter-tag')][1]/span").text.should eql '接收营销邮件 是'
        end
      end

      # 保存分组
      it "should be save" do
        visit customers_path
        fill_in_blur 'customer-search_field', with: '马海波'
        click_on '保存为顾客分组'
        fill_in 'customer_group[name]', with: '大客户'
        click_on '保存'
        within '#customer-groups' do
          find(:xpath, './li[2]').visible?.should be_false # 隐藏当前查询
          within :xpath, './li[6]' do
            has_content?('大客户').should be_true
            find(:xpath, './ul/li[1]').text.should eql '关键字:马海波'
          end
        end
      end

      # 更新分组
      it "should be update" do
        visit customers_path
        within '#customer-groups' do
          find(:xpath, './li[3]').click # 接收营销邮件
        end
        fill_in_blur 'customer-search_field', with: '马海波'
        within '#customer-groups' do
          within :xpath, './li[3]' do
            find(:xpath, './ul/li[1]').text.should eql '关键字:马海波'
            find(:xpath, './ul/li[2]').text.should eql '接收营销邮件 是'
          end
          click_on '更新'
          find_link('更新').visible?.should be_false
        end
      end

      # 删除分组
      it "should be delete" do
        visit customers_path
        within '#customer-groups' do
          has_content?('多次消费').should be_true
          within :xpath, './li[5]' do
            page.execute_script("$('#customer-groups .delete').show()") # 无法模拟鼠标hover，直接显示删除图标
            page.execute_script("window.confirm = function(msg) { return true; }")
            find('.delete').click
          end
          has_content?('多次消费').should be_false
        end
      end

      # 显示分组列表
      it "should list groups" do
        visit customers_path
        within '#customer-groups' do
          group_all = find(:xpath, './li[1]')
          group_all.text.should eql '所有顾客'
          group_all[:class].should include 'active'
          find(:xpath, './li[2]').visible?.should be_false
          within :xpath, './li[3]' do
            find('h3').text.should eql '接收营销邮件'
            find(:xpath, './ul/li[1]').text.should eql '接收营销邮件 是'
          end
          within :xpath, './li[4]' do
            find('h3').text.should eql '潜在顾客'
            find(:xpath, './ul/li[1]').text.should eql '放弃订单时间 在最近一个月'
          end
          within :xpath, './li[5]' do
            find('h3').text.should eql '多次消费'
            find(:xpath, './ul/li[1]').text.should eql '订单数 大于 1'
          end
        end
      end

    end

    describe 'Filter' do

      before :each do
        visit customers_path
        find('#customer-search_field').click # 一点击查询输入框才会显示过滤器
      end

      it "should be add" do
        fill_in 'filter-value', with: '10'
        click_on '新增过滤器'
        select '订单数'
        select '小于'
        fill_in 'filter-value', with: '10'
        click_on '新增过滤器'
        select '下单时间'
        select '在最近一个月'
        click_on '新增过滤器'
        select '接收营销邮件'
        select '是'
        click_on '新增过滤器'
        select '放弃订单时间'
        select '在最近三个月'
        click_on '新增过滤器'
        select '帐号状态'
        select '已禁用'
        click_on '新增过滤器'
        within '#customer-search_filters' do
          find(:xpath, "//div[contains(@class, 'filter-tag')][1]/span").text.should eql '消费金额 大于 10'
          find(:xpath, "//div[contains(@class, 'filter-tag')][2]/span").text.should eql '订单数 小于 10'
          find(:xpath, "//div[contains(@class, 'filter-tag')][3]/span").text.should eql '下单时间 在最近一个月'
          find(:xpath, "//div[contains(@class, 'filter-tag')][4]/span").text.should eql '接收营销邮件 是'
          find(:xpath, "//div[contains(@class, 'filter-tag')][5]/span").text.should eql '放弃订单时间 在最近三个月'
          find(:xpath, "//div[contains(@class, 'filter-tag')][6]/span").text.should eql '帐号状态 已禁用'
        end
        within '#search-filter_summary' do
          has_content?('已有6个过滤器').should be_true
        end
        # 覆盖原有过滤器
        select '消费金额'
        select '大于'
        fill_in 'filter-value', with: '255'
        click_on '新增过滤器'
        within '#customer-search_filters' do
          find(:xpath, "//div[contains(@class, 'filter-tag')][1]/span").text.should eql '消费金额 大于 255'
        end
      end

      it "should be delete" do
        fill_in 'filter-value', with: '10'
        click_on '新增过滤器'
        within '#customer-search_filters' do
          within :xpath, "//div[contains(@class, 'filter-tag')][1]" do
            find('.close-filter-tag').click
          end
        end
        has_no_xpath?("//div[contains(@class, 'filter-tag')][1]").should be_true
      end

      it "should be empty" do
        fill_in 'filter-value', with: '10'
        click_on '新增过滤器'
        find('#search-filter_summary .remove a').click
        has_content?('已有1个过滤器').should be_false
        has_no_xpath?("//div[contains(@class, 'filter-tag')][1]").should be_true
      end

    end

    describe 'Customer' do

      it "should be search" do
        visit customers_path
        find('#customer-search_overlay').visible?.should be_true
        has_content?('找到 2位 顾客').should be_true
        has_content?('李卫辉').should be_true
        fill_in_blur 'customer-search_field', with: '马海波'
        sleep 10
        has_content?('找到 1位 顾客').should be_true
        has_content?('马海波').should be_true
        has_content?('李卫辉').should be_false
      end

      it "should be list" do
        visit customers_path
        within '#customer-table_list' do
          within :xpath, './tr[1]' do
            find('.customer-name a').text.should eql '马海波'
            find(:xpath, './td[4]').text.should eql '广东省深圳市南山区'
            find(:xpath, './td[5]').text.should eql '20' #消费金额
            find(:xpath, './td[6]').text.should eql '1' #订单数
            find(:xpath, './td[7]').text.should eql "#1001 #{Date.today.to_s(:month_and_day)}" #最近订单
          end
        end
      end

    end

  end

  private
  def fill_in_blur(field, options) # 失去焦点触发查询
    fill_in field, options
    page.execute_script("$('##{field}').blur()")
  end

end
