require 'spec_helper'

describe Admin::AccountController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#change_ownership' do

    let(:normal_user) { Factory :normal_user, shop: shop }

    before { user }

    describe 'permissions belong to' do # 权限属于

      describe 'old admin permissions' do # 原管理员权限

        it 'should be add' do # 要重新初始化
          user.permissions.should be_empty
          post :change_ownership, user: { id: normal_user.id }
          user.reload.permissions.should_not be_empty
        end

      end

      describe 'new admin permissions' do # 新管理员权限

        it 'should be clear' do # 被清空
          normal_user.permissions.should_not be_empty
          post :change_ownership, user: { id: normal_user.id }
          normal_user.reload.permissions.should be_empty
        end

      end

    end

  end

end
