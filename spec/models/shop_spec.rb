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

    it 'should init format', focus: true do
      shop.currency.should eql 'CNY'
      shop.money_with_currency_format.should eql '&#165;{{amount}} 元'
      shop.money_format.should eql '&#165;{{amount}}'
      shop.money_with_currency_in_emails_format.should eql '¥{{amount}} 元'
      shop.money_in_emails_format.should eql '¥{{amount}}'
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

end
