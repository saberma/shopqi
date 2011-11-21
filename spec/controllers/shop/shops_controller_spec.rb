require 'spec_helper'

describe Shop::ShopsController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) { Factory(:user_admin).shop }

  let(:iphone4) { Factory.build(:iphone4) }

  before :each do
    shop.themes.install theme
    request.host = "#{shop.primary_domain.host}"
  end

  describe '#preview' do

    before :each do
      shop.update_attributes password_enabled: false
    end

    it 'should show theme controll' do # 右上角显示当前预览主题提示
      get :show, preview_theme_id: shop.theme.id # 跳转后去掉preview_theme_id参数
      get :show
      response.body.should include 'theme-controls'
    end

  end

  describe '#password' do

    context '#protected' do

      it 'should be show' do
        session = mock('session')
        session.stub!(:[], 'storefront_digest').and_return(true)
        controller.stub!(:session).and_return(session)
        controller.stub!(:cart_drop).and_return({}) # 特殊处理，session.stub!(:[], 'cart')会覆盖storefront_digest
        get :show
        response.should be_success
      end

      it 'should be redirect' do
        get :show
        response.should be_redirect
      end

    end

    context '#without protected' do

      before :each do
        shop.update_attributes password_enabled: false
      end

      it 'should be show' do
        get :show
        response.should be_success
      end

      it 'should get css file' do
        get :asset, id: shop.id, theme_id: shop.theme.id, file: 'stylesheet', format: 'css'
        response.should be_success
      end

    end

  end

  context 'https', focus: true do # 不检查控制器，只测试https路由判断

    it 'should get https route' do # 官网、商店后台管理、商店结算
      https?('lvh.me').should be_true
      https?('www.lvh.me').should be_true
      https?('themes.lvh.me').should be_true
      https?('wiki.lvh.me').should be_true
      https?('app.lvh.me').should be_true
      https?('checkout.lvh.me').should be_true
      https?('apple.lvh.me/admin').should be_true
    end

    context 'shop' do # 商店

      it 'should get http route' do
        https?('apple.lvh.me').should be_false # 商店
      end
    end

    context 'search engine' do # 搜索引擎

      it 'should get http route' do
        https?('www.lvh.me', 'Baiduspider+(+http://www.baidu.com/search/spider.htm)').should be_false # 百度
        https?('www.lvh.me', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)').should be_false # Google
      end

    end

  end

  private
  def https?(url, user_agent = nil)
    user_agent ||= 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.2 (KHTML, like Gecko) Ubuntu/10.04 Chromium/15.0.874.106 Chrome/15.0.874.106 Safari/535.2'
    host, path = url.split('/')
    path = "/#{path}"
    request_env = {
      'SERVER_NAME' => host,
      'PATH_INFO' => path,
      'HTTP_USER_AGENT' => user_agent,
    }
    self.stub!(:env).and_return(request_env)
    !ssl_exclude?
  end

  def ssl_exclude? # 此处与config/environments/production.rb中的ssl内容
    return true if env['HTTP_USER_AGENT'] =~ /(bot|crawl|spider)/i # 搜索引擎不使用https协议
    host = env['SERVER_NAME']
    path = env['PATH_INFO']
    if host.end_with?(Setting.store_host) # 二级域名
      not_admin = !path.start_with?('/admin') # 不是后台管理
      return (not_admin and !(Regexp.new("(www|themes|wiki|app|checkout)#{Setting.store_host}") =~ host))
    end
    false
  end

end
