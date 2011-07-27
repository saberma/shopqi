require 'spec_helper'

describe Shop do

  let(:shop) { Factory(:user).shop }

  describe ShopDomain do

    context '#create' do

      it 'should save host' do
        shop.domains.first.host.should_not be_blank
      end

    end

    context '#where' do

      before(:each) { shop }

      it 'should from host' do
        host = "shop.myshopqi.com"
        Shop.at(host).should_not be_nil
      end

    end

  end

end
