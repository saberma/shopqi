#encoding: utf-8
require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers

  before :each do 
    sign_in(Factory(:user_liwh))
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
