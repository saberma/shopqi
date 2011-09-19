require 'spec_helper'

describe ThemesController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  let(:theme) { shop.theme }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#update' do # 发布主题

    it 'should be update' do
      theme.switch Theme.find_by_handle('Prettify') # 原主题会置为[未发布]状态
      prettify_theme = shop.theme
      put :update, id: theme.id, theme: { role: :main }
      theme.reload.role.should eql 'main'
      prettify_theme.reload.role.should eql 'unpublished'
    end

  end

  context '#duplicate' do # 复制主题

    it 'should be duplicate', focus: true do
      expect do
        put :duplicate, id: theme.id
        JSON(response.body)['shop_theme']['role'].should eql 'unpublished'
      end.should change(ShopTheme, :count).by(1)
    end

  end

end
