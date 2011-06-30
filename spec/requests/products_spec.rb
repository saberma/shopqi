# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Products", js: true do

  include_context 'login admin'

  let(:shop) { user_admin.shop }

  let(:iphone4) { Factory :iphone4, shop: shop, product_type: '智能手机', vendor: '苹果' }

  let(:psp) { Factory :psp, shop: shop, product_type: '游戏机', vendor: '索尼' }

  before :each do
    # 删除默认商品，方便测试
    shop.products.clear
    shop.reload
  end

  ##### 新增 #####
  describe "GET /products/new" do

    # 校验
    describe "validate" do

      context "(without types and vendors)" do

        it "should be validate" do
          visit new_product_path
          #显示新增类型、生产商
          find_field('product[product_type]').visible?.should be_true
          find_field('product[vendor]').visible?.should be_true

          click_on '保存'

          #校验
          has_content?('标题 不能为空').should be_true
          has_content?('商品类型 不能为空').should be_true
          has_content?('商品生产商 不能为空').should be_true

          #校验不通过仍然显示新增类型、生产商
          find_field('product[product_type]').visible?.should be_true
          find_field('product[vendor]').visible?.should be_true

          fill_in 'product[product_type]', with: '手机'
          fill_in 'product[vendor]', with: '苹果'

          click_on '保存'

          #校验
          has_content?('标题 不能为空').should be_true
          has_no_content?('商品类型 不能为空').should be_true
          has_no_content?('商品生产商 不能为空').should be_true

          fill_in 'product[title]', with: 'iphone'
          click_on '保存'
          shop.products.all.size.should eql 1
        end

      end

      context "(with types)" do

        it "should be validate" do
          #系统已存在类型
          shop.types.create name: '手机'
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

        it "should be validate" do
          #系统已存在生产商
          shop.vendors.create name: '苹果'
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
        shop.types.create name: '手机'
        shop.vendors.create name: '苹果'
      end

      # 不要求收货地址，则重量置灰
      it "should be bind require_shipping and weight" do
        visit new_product_path
        find_field('product[variants_attributes][][requires_shipping]').checked?.should be_true
        uncheck('product[variants_attributes][][requires_shipping]')
        find_field('product[variants_attributes][][weight]')[:disabled].should eql 'true'

        check('product[variants_attributes][][requires_shipping]')
        find_field('product[variants_attributes][][weight]')[:disabled].should eql 'false'
      end

      # 选项操作
      describe "options" do

        it "should be add" do
          visit new_product_path
          find('#add-option-bt').visible?.should be_false #多选项区域默认不显示
          check '此商品有 多个 不同的款式.'
          # 显示一个默认的选项，并显示新增按钮
          within(:xpath, "//tr[contains(@class, 'edit-option')][1]") do
            find('.option-selector').value.should eql '标题'
            find_field('product[options_attributes][][name]').value.should eql '标题'
            find_field('product[options_attributes][][name]').visible?.should be_false
            find_field('product[options_attributes][][value]').value.should eql '默认标题'
            has_no_css?('.del-option').should be_true # 第一个选项没有删除按钮
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
            has_no_css?('.del-option').should be_true # 第一个选项没有删除按钮
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
          has_no_xpath?("//tr[contains(@class, 'edit-option')][3]").should be_true # 已删除
          find_link('新增另一个选项').visible?.should be_true #显示

          fill_in 'product[title]', with: 'iphone'
          click_on '保存'
          shop.products.all.size.should eql 1

          #款式选项默认值
          within(:xpath, "//tr[contains(@class, 'inventory-row')]") do
            find('.option-1').text.should eql '默认标题'
            find('.option-2').text.should eql '默认大小'
          end

        end

      end

      # 库存操作
      describe "inventory" do

        it "should be ignore" do
          visit new_product_path
          fill_in 'product[title]', with: 'iphone'
          click_on '保存'
          shop.products.first.variants.first.inventory_quantity.should be_nil
        end

        it "should be save" do
          visit new_product_path
          find_field('现有库存量?').visible?.should be_false
          select '需要ShopQi跟踪此款式的库存情况'
          find_field('现有库存量?')[:value].should eql '1'
          fill_in '现有库存量?', with: 10

          click_on '保存'

          find_field('现有库存量?')[:value].should eql '10'

          fill_in 'product[title]', with: 'iphone'
          click_on '保存'
          shop.products.first.variants.first.inventory_quantity.should eql 10
        end

      end

      # 标签操作
      describe "tags" do

        it "should be save" do
          visit new_product_path
          fill_in 'product[tags_text]', with: '智能手机，触摸屏, GPS'

          click_on '保存'

          find_field('product[tags_text]')[:value].should eql '智能手机，触摸屏, GPS'

          fill_in 'product[title]', with: 'iphone'
          click_on '保存'

          has_content?('智能手机').should be_true
          has_content?('触摸屏').should be_true
          has_content?('GPS').should be_true

          # 最近使用
          visit new_product_path
          has_content?('智能手机').should be_true
          has_content?('触摸屏').should be_true
          has_content?('GPS').should be_true
        end

      end

      # 集合操作
      describe "collections" do

        it "should be save" do
          shop.custom_collections.create title: '热门商品'

          visit new_product_path
          check '热门商品'

          click_on '保存'

          find_field('热门商品').checked?.should be_true
          fill_in 'product[title]', with: 'iphone'
          click_on '保存'

          within '#product-edit-collections' do
            has_no_content?('此商品不属于任何集合.').should be_true
            has_content?('热门商品').should be_true
          end
        end

      end

    end

  end

  ##### 列表 #####
  describe "GET /products" do

    context "(with two products)" do

      before :each do
        psp
        iphone4
      end

      # 查询
      it "should be search" do
        visit products_path
        has_content?('iphone4').should be_true
        has_content?('psp').should be_true

        click_on '所有厂商'
        click_on '苹果'
        has_content?('iphone4').should be_true
        has_no_content?('psp').should be_true

        # 苹果手机
        click_on '所有类型'
        click_on '手机'
        has_content?('iphone4').should be_true
        has_no_content?('psp').should be_true

        # 苹果游戏机
        click_on '手机'
        click_on '游戏机'
        has_no_content?('iphone4').should be_true
        has_no_content?('psp').should be_true

        # 索尼游戏机
        click_on '苹果'
        click_on '索尼'
        has_no_content?('iphone4').should be_true
        has_content?('psp').should be_true

        # 索尼手机
        click_on '游戏机'
        click_on '手机'
        has_no_content?('iphone4').should be_true
        has_no_content?('psp').should be_true
      end

      # 显示款式
      it "should show inventory" do
        visit products_path
        within(:xpath, "//table[@id='product-table']/tbody/tr[1]") do
          has_content?('iphone4').should be_true
          has_content?('默认标题').should be_true
          has_content?('∞').should be_true
        end
        within(:xpath, "//table[@id='product-table']/tbody/tr[2]") do
          has_content?('psp').should be_true
          has_content?('默认标题').should be_true
          has_content?('∞').should be_true
        end
      end

      # 快捷操作
      it "should be select" do
        shop.custom_collections.create title: '热门商品'
        visit products_path
        # 发布
        within(:xpath, "//table[@id='product-table']/tbody/tr[1]") do
          check 'products[]'
        end
        select '隐藏'
        within(:xpath, "//table[@id='product-table']/tbody/tr[1]") { find('.status-hidden').visible?.should be_true }
        select '发布'
        within(:xpath, "//table[@id='product-table']/tbody/tr[1]") { find('.status-hidden').visible?.should be_false } #隐藏提示消失
        select '热门商品'
        title = ''
        within(:xpath, "//table[@id='product-table']/tbody/tr[1]/td[3]") { title = find('a').text }
        product = shop.products.where(title: title).first
        product.collections.first.title.should eql '热门商品'
        page.execute_script("window.confirm = function(msg) { return true; }")
        select '删除'
        within("#product-table") { has_no_content?(title).should be_true }
      end

      # 库存视图
      it "should list inventory" do
        variant = iphone4.variants.first
        variant.update_attributes inventory_management: 'shopqi', inventory_quantity: 20, inventory_policy: 'continue'
        visit inventory_products_path
        has_content?('iphone4').should be_true
      end

    end

  end

  describe "GET /products/id" do

    context "(with two products)" do

      before :each do
        iphone4
        psp
      end

      describe '#edit' do

        it 'should save title' do
          visit product_path(iphone4)
          click_on '修改'

          fill_in '标题', with: 'iphone'
          # 类型、生产商
          select '新增类型...', from: 'product-type-select'
          fill_in 'product_type', with: '智能手机'
          select '新增厂商...', from: 'product-vendor-select'
          fill_in 'vendor', with: 'Apple'

          click_on '保存'

          find('#product_title a').text.should eql 'iphone'
          within '#product-options' do
            has_content?('智能手机').should be_true
            has_content?('Apple').should be_true
            has_content?('默认标题').should be_true
          end
        end

        it 'should save options' do
          visit product_path(iphone4)
          click_on '修改'

          click_link '新增另一个选项' # 第二个选项
          within(:xpath, "//tr[contains(@class, 'edit-option')][2]") do
            fill_in 'product[options_attributes][][value]', with: '8G'
          end
          click_on '保存'

          within(:xpath, "//tbody[@id='product-options-list']/tr[1]") do
            find('.option-1 strong').text.should eql '标题'
            find('.option-values-show .small').text.should eql '默认标题'
          end
          within(:xpath, "//tbody[@id='product-options-list']/tr[2]") do
            find('.option-2 strong').text.should eql '大小'
            find('.option-values-show .small').text.should eql '8G'
          end

          click_on '修改'
          click_link '新增另一个选项' # 第三个选项
          within(:xpath, "//tr[contains(@class, 'edit-option')][3]") do
            fill_in 'product[options_attributes][][value]', with: '黑色'
          end
          click_on '保存'

          within(:xpath, "//tbody[@id='product-options-list']/tr[3]") do
            find('.option-3 strong').text.should eql '颜色'
            find('.option-values-show .small').text.should eql '黑色'
          end

          # 款式区域
          within '#row-head' do
            find('#option-header-1').text.should eql '标题'
            find('#option-header-2').text.should eql '大小'
            find('#option-header-3').text.should eql '颜色'
          end
          within :xpath, "//tr[contains(@class, 'inventory-row')]" do
            find('.option-1').text.should eql '默认标题'
            find('.option-2').text.should eql '8G'
            find('.option-3').text.should eql '黑色'
          end
          within('#variant-options') do #快捷选择区域
            find('.option-1').text.should eql '默认标题'
            find('.option-2').text.should eql '8G'
            #find('.option-3').text.should eql '黑色'
          end

          # 回显
          visit product_path(iphone4)

          within(:xpath, "//tbody[@id='product-options-list']/tr[1]") do
            find('.option-1 strong').text.should eql '标题'
            find('.option-values-show .small').text.should eql '默认标题'
          end
          within(:xpath, "//tbody[@id='product-options-list']/tr[2]") do
            find('.option-2 strong').text.should eql '大小'
            find('.option-values-show .small').text.should eql '8G'
          end
          within(:xpath, "//tbody[@id='product-options-list']/tr[3]") do
            find('.option-3 strong').text.should eql '颜色'
            find('.option-values-show .small').text.should eql '黑色'
          end

          page.execute_script("window.alert = function(msg) { return true; }")
          page.execute_script("$('.delete-option-link').removeClass('fr')") # 修改删除按钮不可见无法点击的问题
          click_on '修改'
          within(:xpath, "//tr[contains(@class, 'edit-option')][1]") do
            find('.del-option').click #删除
          end
          click_on '保存'
          within(:xpath, "//tbody[@id='product-options-list']/tr[1]") do
            find('.option-1 strong').text.should eql '大小'
            find('.option-values-show .small').text.should eql '8G'
          end
          within(:xpath, "//tbody[@id='product-options-list']/tr[2]") do
            find('.option-2 strong').text.should eql '颜色'
            find('.option-values-show .small').text.should eql '黑色'
          end

          # 款式区域
          within('#row-head') do
            find('#option-header-1').text.should eql '大小'
            find('#option-header-2').text.should eql '颜色'
            has_no_css?('#option-header-3').should be_true
          end
          within :xpath, "//tr[contains(@class, 'inventory-row')]" do
            find('.option-1').text.should eql '8G'
            find('.option-2').text.should eql '黑色'
          end
          within('#variant-options') do #快捷选择
            find('.option-1').text.should eql '8G'
            find('.option-2').text.should eql '黑色'
          end
        end

        # 款式
        describe 'varaint' do

          it 'should be validate' do
            visit product_path(iphone4)
            find('#new-variant-link a').click
            within '#new-variant' do
              click_on '保存'
              has_content?('基本选项标题 不能为空!').should be_true #必填校验
              fill_in 'product_variant[option1]', with: '默认标题'
              click_on '保存'
              has_content?('基本选项 已经存在!').should be_true #唯一性校验
            end
          end

          it 'should be edit' do
            visit product_path(iphone4)
            within :xpath, "//ul[@id='variants-list']/li[1]" do
              find('.option-1').text.should eql '默认标题'
              click_link '修改'
              find('.inventory-row').visible?.should be_false
              within '.row-edit-details' do
                fill_in 'product_variant[option1]', with: '最新上市'
              end
              click_on '保存'
              find('.option-1').text.should eql '最新上市'
            end
            within('#variant-options') do #快捷选择
              find('.option-1').text.should eql '最新上市'
            end
            has_content?('修改成功!').should be_true
          end

          it 'should be add' do
            visit product_path(iphone4)

            find('#new-variant-link a').click
            within '#new-variant' do
              fill_in 'product_variant[option1]', with: '最新上市'
              click_on '保存'
            end

            within :xpath, "//ul[@id='variants-list']/li[2]" do
              find('.inventory-row .option-1').text.should eql '最新上市'
            end
            within('#variant-options') do #快捷选择
              find('.option-1').text.should eql '默认标题 最新上市'
            end
            has_content?('新增成功!').should be_true
          end

          it 'should update product options' do
            visit product_path(iphone4)

            find('#new-variant-link a').click
            within '#new-variant' do
              fill_in 'product_variant[option1]', with: '最新上市'
              click_on '保存'
            end

            within(:xpath, "//tbody[@id='product-options-list']/tr[1]") do
              find('.option-values-show .small').text.should eql '默认标题,最新上市'
            end

            has_no_xpath?("//tr[contains(@class, 'edit-option')][2]").should be_true # Bug: 不应该新增重复的选项输入项
          end

          # 批量操作
          describe '(batch)' do

            it 'should change price' do
              visit product_path(iphone4)
              check('默认标题')
              within('#product-controls') do
                has_content?('已选中 1 个款式').should be_true
                within('#product-select') do
                  find("option[value='destroy']")[:disabled].should eql 'true' #只剩下一个款式，不能删除
                  find('#dup-option-1')[:disabled].should eql 'false' #只选中一个款式，可以复制
                end
                select '修改价格', from: 'product-select'
                fill_in 'new_value', with: '10'
                click_on '保存'
              end

              has_content?('批量修改成功!').should be_true
              within :xpath, "//ul[@id='variants-list']/li[1]" do
                find('.price-cell').text.should eql '10'
              end
            end

            it 'should be copy' do
              visit product_path(iphone4)
              check('默认标题')
              within('#product-controls') do
                select '…使用另一个标题', from: 'product-select'
                fill_in 'new_value', with: '热卖'
                click_on '保存'
              end
              within :xpath, "//ul[@id='variants-list']/li[2]" do
                find('.option-1').text.should eql '热卖'
              end
            end

            it 'should be delete' do
              visit product_path(iphone4)
              # 新增款式，两个以上才能执行删除操作
              find('#new-variant-link a').click
              within '#new-variant' do
                fill_in 'product_variant[option1]', with: '最新上市'
                click_on '保存'
              end
              check('默认标题')
              within('#product-controls') do
                page.execute_script("window.confirm = function(msg) { return true; }")
                select '删除', from: 'product-select'
              end
              has_content?('批量删除成功!').should be_true
              find('#product-controls').visible?.should be_false
              has_no_xpath?("//ul[@id='variants-list']/li[2]").should be_true
            end

          end

        end

      end

    end

  end

end
