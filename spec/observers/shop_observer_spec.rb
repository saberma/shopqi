require 'spec_helper'

describe ShopObserver do

  let(:shop) { Factory(:user).shop }

  context '#create' do

    describe 'oauth2 consumer' do

      let(:application) { Factory :themes_application }

      before { application }

      it "should create oauth2 access_token", f: true do
        expect do
          shop
        end.to change(Doorkeeper::AccessToken, :count).by(1)
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

    it "should save collection" do
      shop.custom_collections.where(handle: 'frontpage').first.should_not be_nil
    end

    it "should save news blog" do
      shop.blogs.where(handle: 'news').first.should_not be_nil
    end

    it "should set password" do # 设置前台商店访问密码
      shop.password_enabled.should be_true
      shop.password.should_not be_blank
    end

  end

end
