require 'spec_helper'

describe Api::V1::ThemesController do

  let(:shop) { Factory(:user).shop }

  let(:application) { Factory :themes_application } # OAuth application

  let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: 'write_themes' }

  let(:theme_slate) { Factory :theme_woodland_slate }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#install' do # 安装主题

    context 'with scopes' do # 资源访问范围匹配

      it 'should be success' do # issues#228
        expect do
          post :install, handle: theme_slate.handle, style_handle: theme_slate.style_handle, access_token: token.token
          response.should be_success
        end.to change(ShopTheme, :count).by(1)
      end

      describe 'validate' do

        context 'shop storage is not idle' do # 商店容量已用完

          before { Rails.cache.write(shop.storage_cache_key, 101) }

          after { Rails.cache.delete(shop.storage_cache_key) }

          it 'should be fail' do
            post :install, handle: theme_slate.handle, style_handle: theme_slate.style_handle, access_token: token.token
            JSON(response.body)['error'].should_not be_blank
          end

        end
      end

    end

    context 'without scopes' do # 资源访问范围不匹配

      let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: 'read_themes' }

      it 'should be fail' do # 认证失败
        post :install, handle: theme_slate.handle, style_handle: theme_slate.style_handle, access_token: token.token
        response.should_not be_success
        response.status.should eql 401
      end

    end

  end

end
