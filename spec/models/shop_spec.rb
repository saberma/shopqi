require 'spec_helper'

describe Shop do

  let(:shop) { Factory(:user).shop }

  describe 'instance' do

    before(:each) { shop }

    it 'should from host' do
      host = "shopqi#{Setting.store_host}"
      Shop.at(host).should_not be_nil
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

end
