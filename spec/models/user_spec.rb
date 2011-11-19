# encoding: utf-8
require 'spec_helper'

describe User do

  let(:attrs) {
    {
      shop_attributes: {
        name: "测试商店",
        email: 'mahb45@gmail.com',
        domains_attributes:
          [{subdomain: "china", domain: ".myshopqi.com"}],
        province: "110000",
        city: "",
        district: "",
        address: "311",
        zip_code: "518057",
        phone: "13928458888",
        plan: "basic"
      },
      name: "马海波",
      email: "mahb45@gmail.com",
      password: "666666",
      password_confirmation: "666666",
      phone: ""
    }
  }

  context '#create' do

    it 'should be success' do
      expect do
        expect do
          expect do
            User.create attrs
          end.should change(User, :count).by(1)
        end.should change(Shop, :count).by(1)
      end.should change(ShopDomain, :count).by(1)
    end

    describe 'validate', focus: true do

      let(:user_saberma) { Factory :user_saberma }

      context '#email' do

        context '#at same host' do

          it 'should be not unique' do # 不唯一
            user_saberma
            user = user_saberma.shop.users.create({
              name: "马海波",
              email: "mahb45@gmail.com",
              password: "666666",
              password_confirmation: "666666",
            })
            user.errors[:email].should_not be_empty
          end

        end

        context '#at different host' do

          it 'should be unique' do # 唯一
            user_saberma
            user = User.create(attrs)
            user.errors[:email].should be_empty
          end

        end

      end

      context '#password' do

        it 'should be present' do # 不为空
          attrs.delete :password
          user = User.create(attrs)
          user.errors[:password].should_not be_empty
        end

      end

    end

  end

end
