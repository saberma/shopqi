# encoding: utf-8
require 'spec_helper'

describe User do

  let(:attrs_with_shop) do # 包含商店属性，创建商店时使用
    {
      shop_attributes: {
        name: "测试商店",
        email: 'mahb45@gmail.com',
        domains_attributes: [{subdomain: "china", domain: ".myshopqi.com"}],
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
  end

  let(:user_saberma) { Factory :user_saberma }

  context '#create' do

    it 'should be success' do
      expect do
        expect do
          expect do
            user = User.create attrs_with_shop
            user.shop.activities.should_not be_empty
          end.should change(User, :count).by(1)
        end.should change(Shop, :count).by(1)
      end.should change(ShopDomain, :count).by(1)
    end

    describe 'permissions' do # 普通用户权限记录

      it 'should be create' do # 要创建
        user_saberma
        expect do
          Factory :normal_user, shop: user_saberma.shop
        end.should change(Permission, :count)
      end

    end

    describe 'validate' do

      let(:attrs) do # 不包含商店属性，与现有用户重复
        {
          name: "马海波",
          email: "mahb45@gmail.com",
          password: "666666",
          password_confirmation: "666666",
        }
      end

      context '#email' do

        context '#at same host' do

          it 'should be not unique' do # 不唯一
            user_saberma
            user = user_saberma.shop.users.create attrs
            user.errors[:email].should_not be_empty
          end

        end

        context '#at different host' do

          it 'should be unique' do # 唯一
            user_saberma
            user = User.create(attrs_with_shop)
            user.errors[:email].should be_empty
          end

        end

      end

      context '#password' do

        it 'should be present' do # 不为空
          attrs_with_shop.delete :password
          user = User.create(attrs_with_shop)
          user.errors[:password].should_not be_empty
        end

      end

    end

  end

end
