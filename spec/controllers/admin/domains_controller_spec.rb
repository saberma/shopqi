#encoding: utf-8
require 'spec_helper'

describe Admin::DomainsController do

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context 'shop use free plan' do # 免费

    render_views

    before do
      shop.plan = 'free'
      shop.deadline = nil
      shop.save
    end

    it 'should not use domain' do # 无法绑定域名
      get :index
      response.body.should include '免费版无法绑定顶级域名'
      response.body.should_not include '域名管理'
    end

  end

end
