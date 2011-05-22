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

    # 校验
    describe "validate" do

      context "(without types and vendors)" do

        it "should be validate", js: true do
          visit new_product_path
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
          visit new_product_path

          #选中已有类型
          find('#product-type-select').value.should eql '手机'
          find_field('product[product_type]').value.should eql '手机'

          #未选中生产商
          find('#product-vendor-select').value.should eql 'create_new'
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
          visit new_product_path

          #选中已有生产商
          find('#product-vendor-select').value.should eql '苹果'
          find_field('product[vendor]').value.should eql '苹果'

          #未选中生产商
          find('#product-type-select').value.should eql 'create_new'
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

      # 不要求收货地址，则重量置灰
      it "should be bind require_shipping and weight", js: true do
        visit new_product_path
        find_field('product[variants_attributes][][requires_shipping]').checked?.should be_true
        uncheck('product[variants_attributes][][requires_shipping]')
        find_field('product[variants_attributes][][weight]')[:disabled].should eql 'true'

        check('product[variants_attributes][][requires_shipping]')
        find_field('product[variants_attributes][][weight]')[:disabled].should eql 'false'
      end

      # 选项操作
      describe "options" do

        it "should be add", js: true do
          visit new_product_path
          find('#add-option-bt').visible?.should be_false #多选项区域默认不显示
          check '此商品有 多个 不同的款式.'
          # 显示一个默认的选项，并显示新增按钮
          within(:xpath, "//tr[contains(@class, 'edit-option')][1]") do
            find('.option-selector').value.should eql '标题'
            find_field('product[options_attributes][][name]').value.should eql '标题'
            find_field('product[options_attributes][][name]').visible?.should be_false
            find_field('product[options_attributes][][value]').value.should eql '默认标题'
            page.has_no_css?('.del-option') # 第一个选项没有删除按钮
          end
          click_on '新增另一个选项'
          within(:xpath, "//tr[contains(@class, 'edit-option')][2]") do
            find('.option-selector').value.should eql '大小'
            find_field('product[options_attributes][][name]').value.should eql '大小'
            find_field('product[options_attributes][][name]').visible?.should be_false
            find_field('product[options_attributes][][value]').value.should eql '默认大小'
            find('.del-option').visible?.should be_true # 删除按钮可见
            # 不能选择标题
            find("option[value='标题']")[:disabled].should eql 'true'
            find("option[value='大小']")[:disabled].should eql 'false'
          end
          click_on '新增另一个选项'
          within(:xpath, "//tr[contains(@class, 'edit-option')][3]") do
            find('.option-selector').value.should eql '颜色'
            find_field('product[options_attributes][][name]').value.should eql '颜色'
            find_field('product[options_attributes][][name]').visible?.should be_false
            find_field('product[options_attributes][][value]').value.should eql '默认颜色'
            find('.del-option').visible?.should be_true # 删除按钮可见
            # 不能选择标题、大小
            find("option[value='标题']")[:disabled].should eql 'true'
            find("option[value='大小']")[:disabled].should eql 'true'
            find("option[value='颜色']")[:disabled].should eql 'false'
            # 换下名称
            select '材料'
            find_field('product[options_attributes][][name]').value.should eql '材料'
            find_field('product[options_attributes][][name]').visible?.should be_false
            find_field('product[options_attributes][][value]').value.should eql '默认材料'
            # 自定义
            select '自定义...'
            find_field('product[options_attributes][][name]').value.should eql ''
            fill_in 'product[options_attributes][][name]', with: '容量'
            fill_in 'product[options_attributes][][value]', with: '16G'
          end
          find_link('新增另一个选项').visible?.should be_false #超过三个选项就隐藏按钮
          click_on '保存'

          # 正常回显
          find_field('此商品有 多个 不同的款式.').checked?.should be_true
          find_link('新增另一个选项').visible?.should be_false #超过三个选项就隐藏按钮
          within(:xpath, "//tr[contains(@class, 'edit-option')][1]") do
            find('.option-selector').value.should eql '标题'
            find_field('product[options_attributes][][name]').value.should eql '标题'
            find_field('product[options_attributes][][name]').visible?.should be_false
            find_field('product[options_attributes][][value]').value.should eql '默认标题'
            page.has_no_css?('.del-option') # 第一个选项没有删除按钮
            # 不能选择大小
            find("option[value='标题']")[:disabled].should eql 'false'
            find("option[value='大小']")[:disabled].should eql 'true'
          end
          within(:xpath, "//tr[contains(@class, 'edit-option')][2]") do
            find('.option-selector').value.should eql '大小'
            find_field('product[options_attributes][][name]').value.should eql '大小'
            find_field('product[options_attributes][][name]').visible?.should be_false
            find_field('product[options_attributes][][value]').value.should eql '默认大小'
            find('.del-option').visible?.should be_true # 删除按钮可见
            # 不能选择标题
            find("option[value='标题']")[:disabled].should eql 'true'
            find("option[value='大小']")[:disabled].should eql 'false'
          end
          within(:xpath, "//tr[contains(@class, 'edit-option')][3]") do
            find('.option-selector').value.should eql 'create_new'
            find_field('product[options_attributes][][name]').value.should eql '容量'
            find_field('product[options_attributes][][value]').value.should eql '16G'
            find('.del-option').visible?.should be_true # 删除按钮可见
            # 不能选择标题、大小
            find("option[value='标题']")[:disabled].should eql 'true'
            find("option[value='大小']")[:disabled].should eql 'true'
          end

          # 删除
          within(:xpath, "//tr[contains(@class, 'edit-option')][3]") do
            find('.del-option').click
          end
          page.has_no_xpath? "//tr[contains(@class, 'edit-option')][3]" # 已删除
          find_link('新增另一个选项').visible?.should be_true #显示

          fill_in 'product[title]', with: 'iphone'
          click_on '保存'
          shop.products.all.size.should eql 1

          #款式选项默认值
          #within(:xpath, "//tr[contains(@class, 'inventory-row')][1]") do
          #  find('.option-1').should have_content('默认标题') 
          #  find('.option-2').should have_content('默认大小')
          #end
        end

      end

    end

  end

end
