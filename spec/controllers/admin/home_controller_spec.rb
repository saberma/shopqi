require 'spec_helper'

describe Admin::HomeController do

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context 'installed application' do # 已安装应用

    render_views

    let(:application) { Factory :express_application } # OAuth application

    before do # 商店授权
      application.access_tokens.create! resource_owner_id: shop.id, expires_in: Doorkeeper.configuration.access_token_expires_in, scopes: 'read_orders'
    end

    it 'should be list' do # 在后台管理的应用列表中显示
      get :dashboard
      response.body.should include application.name
      response.body.should include "#{application.redirect_uri}_login?shop=#{shop.shopqi_domain}" # 登录地址
    end

  end

end
