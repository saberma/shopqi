# encoding: utf-8
require 'spec_helper'

describe "Products" do

  let(:user_admin) { Factory :user_admin }

  let(:shop) { user_admin.shop }

  before :each do
    visit new_user_session_path
    fill_in 'user[email]', with: user_admin.email
    fill_in 'user[password]', with: user_admin.password
    click_on 'log in'
  end

  describe "GET /products/new" do

    before :each do
      visit new_product_path
    end

    it "should be bind require_shipping and weight", js: true do
      find_field('product[variants_attributes][][requires_shipping]').checked?.should be_true
      uncheck('product[variants_attributes][][requires_shipping]')
      find_field('product[variants_attributes][][weight]')['disabled'].should eql 'true'

      check('product[variants_attributes][][requires_shipping]')
      find_field('product[variants_attributes][][weight]')['disabled'].should eql 'false'
    end

    describe "options" do

      it "should be add", js: true do
        check('enable-options')
        # 显示一个默认的选项，并显示新增按钮
        find('#add-option-bt').visible?.should be_true
      end

    end

    describe "validate" do

      context "(without types and vendors)" do

        it "should be validate", js: true do
          #显示新增类型、生产商
          find_field('product[product_type]').visible?.should be_true
          find_field('product[vendor]').visible?.should be_true

          click_on '保存'

          #校验
          page.should have_content('标题 不能为空')
          page.should have_content('商品类型 不能为空')
          page.should have_content('商品生产商 不能为空')

          #校验不通过仍然显示新增类型、生产商
          find_field('product[product_type]').visible?.should be_true
          find_field('product[vendor]').visible?.should be_true

          fill_in 'product[product_type]', with: '手机'
          fill_in 'product[vendor]', with: '苹果'

          click_on '保存'

          #校验
          page.should have_content('标题 不能为空')
          page.should_not have_content('商品类型 不能为空')
          page.should_not have_content('商品生产商 不能为空')

          fill_in 'product[title]', with: 'iphone'

          click_on '保存'
          shop.products.all.size.should eql 1
        end

      end

      context "(with types)" do

        it "should be validate", js: true do
          #系统已存在类型
          shop.types.create title: '手机'

          #选中已有类型
          find('#product-type-select').value.should eql '手机'
          find_field('product[product_type]').value.should eql '手机'

          #未选中生产商
          find('#vendor-select').value.should eql ''
          find_field('product[vendor]').value.should eql ''

          #隐藏新增类型、显示生产商
          find_field('product[product_type]').visible?.should be_false
          find_field('product[vendor]').visible?.should be_true
        end

      end

      context "(with vendors)" do

        it "should be validate", js: true do
          #系统已存在生产商
          shop.vendors.create title: '苹果'

          #选中已有生产商
          find('#vendor-select').value.should eql '苹果'
          find_field('product[vendor]').value.should eql '苹果'

          #未选中生产商
          find('#product-type-select').value.should eql ''
          find_field('product[product_type]').value.should eql ''

          #显示新增类型、隐藏生产商
          find_field('product[product_type]').visible?.should be_true
          find_field('product[vendor]').visible?.should be_false
        end

      end

    end

    context "(with types and vendors)" do

      before :each do
        #系统已存在类型、生产商
        shop.types.create title: '手机'
        shop.vendors.create title: '苹果'
      end

    end

  end

  describe "GET /products" do
    it "works!" do
      get products_path
      response.status.should be(200)
    end
  end

end
