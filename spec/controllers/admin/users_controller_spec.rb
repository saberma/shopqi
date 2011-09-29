#encoding: utf-8
require 'spec_helper'

describe Admin::UsersController do
  include Devise::TestHelpers

  let(:user) { Factory(:user_liwh) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#create' do

    describe 'validate' do

      it 'should accept Terms and conditions' do # 服务条款
      end

    end

  end

  context '#update' do
    it 'with password' do
      post :update, user:{name:'liwh', phone:'222', bio:'222aa', email:'liwh87@gmail.com', password:"", password_confirmation:"", "receive_announcements"=>"1"}, id:User.find_by_email("liwh87@gmail.com").id
      response.should be_redirect
      flash[:notice].should == '修改成功!'
    end
  end

end
