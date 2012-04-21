#encoding: utf-8
require 'spec_helper'

describe Shopqi::RegistrationsController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:attrs_with_shop) do # 包含商店属性，创建商店时使用
    {
      user: {
        shop_attributes: {
          name: "测试商店",
          email: 'mahb45@gmail.com',
          domains_attributes: [{subdomain: "china", domain: ".myshopqi.com"}],
          themes_attributes: [{theme_id: theme.id}],
          province: "110000",
          city: "",
          district: "",
          address: "311",
          zip_code: "518057",
          phone: "13928458888",
          plan: "professional"
        },
        name: "马海波",
        email: "mahb45@gmail.com",
        password: "666666",
        password_confirmation: "666666",
        phone: ""
      }
    }
  end

  before do
    #  Maybe you forgot to wrap your route inside the scope block? For example:
    #    devise_scope :user do
    #      match "/some/route" => "some_devise_controller"
    #    end
    @request.env["devise.mapping"] = Devise.mappings[:user] # rspec controllers没有使用route中的信息，所以会出现已经定义了devise :user但仍提示未定义 http://j.mp/v4MP0i
    request.host = "www.#{Setting.host}"
  end
  
  describe Activity do # #428

    let(:user) { Factory(:user) }

    before do
      ActivityObserver.current_user = user # 用户A在后台管理操作后，线程的current_user会设置为用户A
    end

    it "should not save activity's user_id" do
      post :create, attrs_with_shop
      Shop.last.activities.last.user.should be_nil
      response.should be_success
    end

  end

end
