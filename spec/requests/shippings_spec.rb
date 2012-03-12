#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shippings", js: true do

  include_context 'login admin'

  before :each do
    visit shippings_path
  end

  describe "GET /admin/shipping" do

    describe Shipping do

      it "should be index" do # 显示列表
        page.should have_content('全国') # 默认记录
        page.should have_content('普通快递') # 默认记录
        page.should have_content('0kg - 25kg')
        page.should have_content('10元')
      end

      it "should be add" do # 新增
        click_on '新增目的地'
        within '#new-region' do
          select '广东省', form: 'province'
          select '深圳市', form: 'city'
          select '南山区', form: 'district'
          click_on '保存'
        end
        has_content?('新增成功!').should be_true
        within '#custom-shipping' do
          find(:xpath, './table[2]//th[1]').text.should eql '广东省深圳市南山区'
        end
      end

      it "should be destroy" do # 删除
        within '#custom-shipping' do
          within :xpath, './table[1]' do
            page.execute_script("window.confirm = function(msg) { return true; }")
            find('.del').click
          end
          page.should have_no_xpath('./table[1]')
        end
      end

    end

    describe WeightBasedShippingRate do

      it "should be success" do # 新增
        within '#custom-shipping' do
          within :xpath, './table[1]' do
            click_on '新增基于重量的费用'
            within '.new-standard-rate' do
              click_on '取消'
            end
            click_on '新增基于重量的费用'
            within '.new-standard-rate' do
              fill_in 'name', with: '顺丰快递'
              fill_in 'weight_low', with: '25'
              fill_in 'weight_high', with: '50'
              fill_in 'price', with: '80'
              click_on '保存'
            end
          end
        end
        page.should have_content('新增成功!')
        within 'tbody.standard-rate' do
          within :xpath, './tr[2]' do
            find(:xpath, './td[1]').text.should eql '顺丰快递'
            find(:xpath, './td[2]').text.should eql '25kg - 50kg'
            find(:xpath, './td[3]').text.should eql '¥80元'
          end
        end
      end

      it "should be edit" do # 修改
        within '#custom-shipping' do
          within :xpath, './table[1]' do
            within 'tbody.standard-rate' do
              within :xpath, './tr[1]' do
                click_on '普通快递'
              end
            end
          end
        end
        page.should have_content('普通快递')
        page.should have_content('0.0kg 到 25.0kg')
        page.should have_content('¥10.0 元')
        click_on '编辑'
        fill_in '名称', with: 'EMS'
        fill_in 'weight_based_shipping_rate[weight_low]', with: '25'
        fill_in 'weight_based_shipping_rate[weight_high]', with: '50'
        fill_in 'weight_based_shipping_rate[price]', with: '80'
        click_on '保存'
        page.should have_content('顺丰快递')
        page.should have_content('25.0kg 到 50.0kg')
        page.should have_content('¥80.0 元')
      end

      it "should be destroy" do # 删除
        within '#custom-shipping' do
          within :xpath, './table[1]' do
            within 'tbody.standard-rate' do
              within :xpath, './tr[1]' do
                page.execute_script("window.confirm = function(msg) { return true; }")
                find('.del').click
              end
            end
          end
        end
        page.should have_content('删除成功!')
        within '#custom-shipping' do
          within :xpath, './table[1]' do
            within 'tbody.standard-rate' do
              page.should have_no_xpath('./tr[1]')
            end
          end
        end
      end

    end

    describe PriceBasedShippingRate, f: true do

      context 'add' do

        it "should be success" do # 新增
          within '#custom-shipping' do
            within :xpath, './table[1]' do
              click_on '新增基于价格的费用'
              within '.new-promotional-rate' do
                click_on '取消'
              end
              click_on '新增基于价格的费用'
              within '.new-promotional-rate' do
                fill_in 'name', with: '顺丰快递'
                fill_in 'min_order_subtotal', with: '100'
                click_on '以上'
                fill_in 'max_order_subtotal', with: '150'
                fill_in 'price', with: '120'
                click_on '保存'
              end
            end
          end
          page.should have_content('新增成功!')
          within 'tbody.promotional-rate' do
            within :xpath, './tr[1]' do
              find(:xpath, './td[1]').text.should eql '顺丰快递'
              find(:xpath, './td[2]').text.should eql '¥100 - 150'
              find(:xpath, './td[3]').text.should eql '¥120元'
            end
          end
        end

        it "should hide max subtotal" do # 可以隐藏最大价格
          within '#custom-shipping' do
            within :xpath, './table[1]' do
              click_on '新增基于价格的费用'
              within '.new-promotional-rate' do
                find('.edit-max-purchase').visible?.should be_false
                click_on '以上'
                fill_in 'min_order_subtotal', with: '150'
                find('.edit-max-purchase').visible?.should be_true
              end
            end
          end
        end

      end

      context 'with record' do # 已经存在记录

        before do
          within '#custom-shipping' do
            within :xpath, './table[1]' do
              click_on '新增基于价格的费用'
              within '.new-promotional-rate' do
                fill_in 'name', with: '顺丰快递'
                fill_in 'min_order_subtotal', with: '100'
                fill_in 'price', with: '120'
                click_on '保存'
              end
            end
          end
        end

        it "should be edit" do # 修改
          within '#custom-shipping' do
            within :xpath, './table[1]' do
              within 'tbody.promotional-rate' do
                within :xpath, './tr[1]' do
                  click_on '顺丰快递'
                end
              end
            end
          end
          page.should have_content('顺丰快递')
          page.should have_content('¥100.0 最少')
          page.should have_content('¥120.0 元')
          click_on '编辑'
          fill_in '名称', with: 'EMS'
          fill_in 'price_based_shipping_rate[min_order_subtotal]', with: '200'
          click_on '以上'
          fill_in 'price_based_shipping_rate[max_order_subtotal]', with: '300'
          fill_in 'price_based_shipping_rate[price]', with: '160'
          click_on '保存'
          page.should have_content('顺丰快递')
          page.should have_content('¥200.0 - ¥300.0')
          page.should have_content('¥160.0 元')
        end

        it "should be destroy" do # 删除
          within '#custom-shipping' do
            within :xpath, './table[1]' do
              within 'tbody.promotional-rate' do
                within :xpath, './tr[1]' do
                  page.execute_script("window.confirm = function(msg) { return true; }")
                  find('.del').click
                end
              end
            end
          end
          page.should have_content('删除成功!')
          within '#custom-shipping' do
            within :xpath, './table[1]' do
              within 'tbody.promotional-rate' do
                page.should have_no_xpath('./tr[1]')
              end
            end
          end
        end

      end

    end

  end

end
