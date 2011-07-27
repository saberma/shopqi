# encoding: utf-8
require 'spec_helper'

describe User do

  context '#create' do

    describe 'validate' do

      describe 'shop' do

        it 'should validate name' do
        end

      end

      describe 'domain' do

        it 'should validate subdomain' do
        end

        it 'should validate domain' do
        end

        it 'should be at least 4 characters' do
        end

      end

    end

    it 'should be success' do
      expect do
        expect do
          expect do
            attrs = {
              shop_attributes: {
                name: "测试商店",
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
            User.create attrs
          end.should change(User, :count).by(1)
        end.should change(Shop, :count).by(1)
      end.should change(ShopDomain, :count).by(1)
    end

  end

end
