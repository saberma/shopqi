# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shopqi::Registrations", js: true do

  include_context 'use shopqi host'

  let(:user_admin) {  Factory :user_admin }

  let(:shop) { user_admin.shop }

  describe "GET /signup" do

    before(:each) do
      visit '/services/signup/new/basic'
    end

    describe "signup" do

      it "should be save" do
        fill_in 'shop[name]'       , with: '苹果专卖'
        fill_in 'domain[subdomain]', with: 'apple'
        click_on '跳过这一步'
        fill_in '姓名'             , with: '马波'
        select '广东省'
        select '深圳市'
        select '南山区'
        fill_in '地址'             , with: '311'
        fill_in '邮编'             , with: '517058'
        fill_in '电话'             , with: '0755-26748888'
        fill_in 'Email地址'        , with: 'mahb45@gmail.com'
        fill_in '密码'             , with: '666666'
        fill_in '确认密码'         , with: '666666'
        fill_in '手机'             , with: '13928452841'
        fill_in '手机验证码'       , with: '8888'
        check 'shop_terms_and_conditions' # 服务条款
        click_on '创建我的ShopQi商店'
        sleep 5 # 等待后台保存shop对象
        has_content?('ShopQi欢迎您').should be_true
      end

    end

    describe "verify code" do

      before(:each) { SMS.stub!(:safe_send) } # 测试环境不要发短信

      it "should require phone" do
        click_on '获取验证码'
        find('#user_phone_hint').visible?.should be_true
        has_content?('请输入正确的手机号码').should be_true
      end

      it "should be disable" do
        fill_in '手机', with: '13928452841'
        click_on '获取验证码'
        find('#check_phone')[:disabled].should be_true
        sleep 5 # 暂时没有方法测试button中不断变化的value值
        find('#check_phone').value.start_with?('已发送,请检查短信(如未收到').should be_true
      end

    end

    describe "themes" do

      it "should be index" do
        page.has_css?('#initial-themes li').should be_true
        find('#more-themes').visible?.should be_false
        click_on '显示更多主题'
        find('#more-themes').visible?.should be_true
      end

      it "should be select" do
        find('#themes-section').visible?.should be_true
        find('#initial-themes li.theme a.next').click
        sleep 3
        find('#current-theme').visible?.should be_true # 选中主题
        find('#themes-section').visible?.should be_false
        find('#selected-theme').value.should_not be_blank
      end

      it "should be skip" do
        click_on '跳过这一步' # 选中第一个主题
        click_on '选择其他主题'
        sleep 3
        find('#themes-section').visible?.should be_true
        find('#current-theme').visible?.should be_false
        find('#selected-theme').value.should be_blank
      end

      it "should be preview" do
        find('#initial-themes li.theme a.preview').click
        find('#fancybox-wrap').visible?.should be_true
      end

    end

    describe "subdomain" do

      it "should be valid" do
        fill_in 'domain[subdomain]', with: 'apple'
        within '#domain-available' do
          has_content?('恭喜，apple.smackaho.st 可以使用').should be_true
        end
      end

      it "should be invalid" do
        subdomain = shop.primary_domain.subdomain
        fill_in 'domain[subdomain]', with: subdomain
        within '#domain-available' do
          has_content?("抱歉，#{subdomain}.smackaho.st 已经 被使用了").should be_true
        end
      end

    end

    describe "validate" do

      it "should require shop name and subdomain" do
        click_on '创建我的ShopQi商店'
        has_content?('请给您的商店取个名字').should be_true
        has_content?('请为您的商店挑选Web地址').should be_true
        fill_in 'shop[name]', with: '苹果专卖'
        fill_in 'domain_subdomain', with: 'apple'
        click_on '创建我的ShopQi商店'
        has_content?('请给您的商店取个名字').should be_false
        has_content?('请为您的商店挑选Web地址').should be_false
        has_content?('姓名 不能为空').should be_true
        has_content?('省份 不能为空').should be_true
        has_content?('城市 不能为空').should be_true
        has_content?('地区 不能为空').should be_true
        has_content?('地址 不能为空').should be_true
        has_content?('电话 不能为空').should be_true
        has_content?('Email地址 不能为空').should be_true
        has_content?('密码 不能为空').should be_true
        has_content?('确认密码 不能为空').should be_true
        has_content?('手机 不能为空').should be_true
        has_content?('手机验证码 不能为空').should be_true
        has_content?('请您先阅读并接受服务条款').should be_true
      end

    end

  end

end
