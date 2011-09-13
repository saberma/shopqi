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
    o.save
    o.update_attribute :financial_status, :pending # 修改为pending会增加消费金额
    o
  end

  let(:customer) { shop.customers.where(name: '马海波').first }

  before :each do
    order
  end

  ##### 新增 #####
  describe "GET /customers/new" do

    before(:each) { visit new_customer_path }

    it "should be validate" do
      shop
      click_on '保存'
      within '#message_block' do
        has_content?('姓名 不能为空').should be_true
        has_content?('邮箱 不能为空').should be_true
      end
      fill_in '姓名', with: '马海波'
      fill_in '邮箱', with: 'mahb45@gmail.com'
      click_on '保存'
      within '#message_block' do
        has_content?('邮箱 已经存在').should be_true
      end
    end

    # 保存
    it "should be save" do
      within '#new-customer-screen' do
        fill_in '姓名', with: '马海波'
        fill_in '邮箱', with: 'saberma@shopqi.com'
        fill_in '公司', with: '索奇'
        fill_in '电话', with: '13928452888'
        select '北京市'
        select '市辖区'
        select '东城区'
        fill_in '地址', with: '中关村311'
        fill_in '邮编', with: '517058'
        uncheck 'customer[accepts_marketing]'
        fill_in 'customer[note]', with: '开发者'
        fill_in 'customer[tags_text]', with: '无效用户'
      end
      click_on '保存'
      has_no_css?('#new-customer-screen').should be_true
      within '#customer-summary' do
        has_content?('马海波').should be_true
        has_content?('13928452888').should be_true
        has_content?('北京市').should be_true
        has_content?('市辖区').should be_true
        has_content?('东城区').should be_true
        has_content?('中关村311').should be_true
      end
    end

  end

  ##### 查看 #####
  describe "GET /customers/id" do

    before(:each) { visit customer_path(customer) }

    describe "Show" do

      # 基本信息
      it "should show info" do
        within '#customer-summary .first' do
          has_content?('马海波').should be_true
          has_content?('mahb45@gmail.com').should be_true
          has_content?('13928452888').should be_true
        end
        within '#customer-summary' do
          has_content?('广东省').should be_true
          has_content?('深圳市').should be_true
          has_content?('南山区').should be_true
        end
      end

      # 更多地址
      it "should show more address" do
        customer.addresses.create name: '马海波', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13928452888'
        visit customer_path(customer)
        click_on '另外 1 个地址…'
        within '#more-customer-addresses' do
          has_content?('马海波').should be_true
          has_content?('广东省').should be_true
          has_content?('深圳市').should be_true
          has_content?('南山区').should be_true
        end
        click_on '隐藏地址…'
        find('#more-customer-addresses').visible?.should be_false
        find('#customer-note .notes').text.should eql '暂时没有加入备注.'
      end

      # 统计
      it "should show statics" do
        within '#customer-facts' do
          find(:xpath, './/li[1]').find('.big').text.should eql '¥20'
          find(:xpath, './/li[2]').find('.big').text.should eql '1'
          find(:xpath, './/li[3]').find('.big').text.should eql Date.today.to_s(:db)
        end
      end

      # 订单列表
      it "should list orders" do
        within '#order-table tbody' do
          within :xpath, './/tr[1]' do
           find(:xpath, './td[1]').text.should eql order.name
           find(:xpath, './td[2]').text.should eql Date.today.to_s(:month_and_day)
           find(:xpath, './td[3]').text.should eql '待支付'
           find(:xpath, './td[4]').text.should eql '未发货'
           find(:xpath, './td[5]').text.should eql '¥20'
          end
        end
      end

    end

    describe "Edit" do

      it "should be save" do
        click_on '编辑'
        within '#edit-customer-screen' do
          has_content?('mahb45@gmail.com').should be_true
          fill_in 'customer[name]', with: '马波'
          fill_in 'name', with: '李卫辉'
          fill_in '公司', with: '索奇'
          fill_in '电话', with: '13751042627'
          select '北京市'
          select '市辖区'
          select '东城区'
          fill_in '地址', with: '中关村311'
          fill_in '邮编', with: '517058'
          uncheck 'customer[accepts_marketing]'
          fill_in 'customer[note]', with: '开发者'
          fill_in 'customer[tags_text]', with: '无效用户'
        end
        click_on '保存'
        within '#customer-summary' do
          has_content?('李卫辉').should be_true
          has_content?('13751042627').should be_true
          has_content?('马波').should be_true
          has_content?('北京市').should be_true
          has_content?('市辖区').should be_true
          has_content?('东城区').should be_true
          has_content?('中关村311').should be_true
        end
        find('#customer-note .notes').text.should eql '开发者'
        find('#customer-tags p').text.should eql '无效用户'
        visit customer_path(customer)
        within '#customer-summary' do
          has_content?('李卫辉').should be_true
          has_content?('13751042627').should be_true
          has_content?('马波').should be_true
          has_content?('北京市').should be_true
          has_content?('市辖区').should be_true
          has_content?('东城区').should be_true
          has_content?('中关村311').should be_true
        end
        find('#customer-note .notes').text.should eql '开发者'
        find('#customer-tags p').text.should eql '无效用户'
      end

    end

  end

  ##### 列表 #####
  describe "GET /customers" do

    describe 'Group' do

      before(:each) do
        shop.customer_groups.create [
          { name: '接收营销邮件', query: 'accepts_marketing:yes:接收营销邮件:是' }                         ,
          { name: '潜在顾客'    , query: 'last_abandoned_order_date:last_month:放弃订单时间:在最近一个月' },
          { name: '多次消费'    , query: 'orders_count_gt:1:订单数 大于:1' }                               ,
        ]
      end

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
          sleep 3 # 延时处理
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
          sleep 3 # 延时处理
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

      before(:each) do
        customer # 注意:此顾客信息在初始化订单时会被创建 See: OrderObserver
        Factory(:customer_liwh, shop: shop)
      end

      it "should be search" do
        visit customers_path
        has_content?('找到 2位 顾客').should be_true
        has_content?('李卫辉').should be_true
        fill_in_blur 'customer-search_field', with: '马海波'
        sleep 5
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
