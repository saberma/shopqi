# encoding: utf-8
require 'spec_helper'

describe Shop do

  let(:shop) { Factory(:user).shop }

  describe 'instance' do

    before(:each) { shop }

    it 'should from host' do
      host = "shopqi#{Setting.store_host}"
      Shop.at(host).should_not be_nil
    end

    describe 'money' do # 币种

      it 'should init format' do
        shop.currency.should eql 'CNY'
        shop.money_with_currency_format.should eql '&#165;{{amount}} 元'
        shop.money_format.should eql '&#165;{{amount}}'
        shop.money_with_currency_in_emails_format.should eql '¥{{amount}} 元'
        shop.money_in_emails_format.should eql '¥{{amount}}'
      end

      it 'should format money', focus: true do # 传入金额，返回格式化后的金额
        shop.format_money_with_currency(19.95).should eql '&#165;19.95 元'
        shop.format_money(19.95).should eql '&#165;19.95'
        shop.format_money_with_currency_in_emails(19.95).should eql '¥19.95 元'
        shop.format_money_in_emails(19.95).should eql '¥19.95'
      end

    end

    describe 'plan' do # 商店帐号类型

      let(:theme) { Factory :theme_woodland_dark }

      it 'should get storage' do # 已占用的容量
        shop.themes.install theme
        shop.storage.should_not eql 0
        shop.storage_idle?.should be_true
      end

      context 'paid' do # 收费版本

        it 'should init deadline' do # 有截止时间
          shop.deadline.should_not be_nil
        end

      end


      context 'free' do # 免费版本

        let(:free_shop) { Factory(:free_user).shop }

        it 'should not init deadline' do # 没有截止时间
          free_shop.deadline.should be_nil
        end

      end

    end

  end

  describe 'validate' do

    it 'should validate name' do
      s = Shop.create
      s.errors[:name].should_not be_empty
    end

  end

  describe ShopDomain do

    context '#create' do

      it 'should save host' do
        domain = ShopDomain.create subdomain: 'shop', domain: '.myshopqi.com'
        domain.host.should_not be_blank
      end

    end

    describe 'validate' do

      it 'should validate subdomain' do
        domain = ShopDomain.create domain: '.myshopqi.com'
        domain.errors[:subdomain].should_not be_empty
      end

      it 'should be at least 3 characters' do
        domain = ShopDomain.create subdomain: 'xx',  domain: '.myshopqi.com'
        domain.errors[:subdomain].should_not be_empty
      end

      it 'should be unique' do
        ShopDomain.create subdomain: 'shop',  domain: '.myshopqi.com'
        domain = ShopDomain.create subdomain: 'shop',  domain: '.myshopqi.com'
        domain.errors[:host].should_not be_empty
      end

    end

  end

  describe ShopTask do

    context '#launch' do

      it 'should update shop' do
        shop.tasks.each do |task|
          task.update_attributes completed: true unless task.is_launch?
        end
        shop.guided.should be_false
        shop.password_enabled.should be_true
        launch_task = shop.tasks.last
        launch_task.update_attributes! completed: true
        shop.reload
        shop.guided.should be_true
        shop.password_enabled.should be_false
      end

    end

  end

  describe User do # 管理员

    context '#permissions' do # 权限记录

      it 'should not be create' do # 不需要创建
        expect do
          shop
        end.should_not change(Permission, :count)
      end

    end

  end

end
