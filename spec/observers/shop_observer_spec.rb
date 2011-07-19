require 'spec_helper'

describe ShopObserver do

  let(:shop) { Factory(:user).shop }

  context '#create' do

    describe 'oauth2 consumer' do

      let(:client) { Factory(:oauth2_client) }

      before(:each) do
        client
        Theme.should_receive(:client_id).and_return(client.client_id)
      end

      it "should create oauth2 access_token" do
        expect do
          expect do
            shop
            shop.oauth2_authorizations.first.access_token_hash.should_not be_blank
            shop.oauth2_consumers.first.access_token.should_not be_blank
          end.to change(OAuth2::Model::Authorization, :count).by(1)
        end.to change(OAuth2::Model::Consumer, :count).by(1)
      end

    end

    it "should save link list" do
      expect do
        expect do
          shop
        end.to change(LinkList, :count).by(2)
      end.to change(Link, :count).by(5)
    end

    it "should save page" do
      expect do
        shop
      end.to change(Page, :count).by(2)
    end

    it "should save collection and products" do
      shop.custom_collections.where(handle: :frontpage).first.should_not be_nil
      shop.products.empty?.should be_false
    end

    it "should save latest-news blog" do
      shop.blogs.where(handle: 'latest-news').first.should_not be_nil
    end

  end
  
end
