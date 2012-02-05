# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Payments", js: true do

  include_context 'login admin'

  let(:payment_alipay) { Factory :payment_alipay, shop: shop } # 支付宝

  describe "GET /admin/payments" do

    describe "Alipay" do # 支付宝

      context 'do not configed' do # 已经配置

        before { visit payments_path }

        it "should be config", f: true do # 配置
          within '#payment_alipay' do
            select '使用支付宝'
            find('.account_payment_provider').visible?.should be_true
            click_on '取消'
            find('.account_payment_provider').visible?.should be_false
            select '使用支付宝'

            fill_in '合作者身份ID', with: '2398072190767748'
            fill_in '帐号', with: 'mahb45@gmail.com'
            fill_in '交易安全校验码', with: '1111'
            select '担保交易'
            click_on '保存'
          end
          page.should have_content('修改成功!')
          within '#payment_alipay' do
            find('.account_payment_provider').visible?.should be_false
            page.should have_content('支付宝担保交易服务')
            visit payments_path # 回显
            page.should have_content('支付宝担保交易服务')
            find('.account_payment_provider').visible?.should be_false
          end
        end

        describe "validate" do # 校验

          it "should be validate" do
            within '#payment_alipay' do
              select '使用支付宝'
              click_on '保存'
            end
            page.should have_content('合作者身份ID 不能为空. 帐号 不能为空. 交易安全校验码 不能为空.')
          end

        end

      end

      context 'configed' do # 已经配置

        before do
          payment_alipay
          visit payments_path
        end

        it "should be edit" do # 修改
          within '#payment_alipay' do
            page.should have_content('支付宝即时到帐服务')
            find('.account_payment_provider').visible?.should be_false
            click_on '编辑'
            find('.account_payment_provider').visible?.should be_true # 显示表单
            click_on '取消' # 可取消
            find('.account_payment_provider').visible?.should be_false
            click_on '编辑'

            fill_in '合作者身份ID', with: '2398072190768888'
            fill_in '帐号', with: 'mahb45@example.com'
            fill_in '交易安全校验码', with: '2222'
            select '担保交易'
            click_on '保存'
          end
          page.should have_content('修改成功!')

          alipay = shop.payments.alipay
          alipay.partner.should eql '2398072190768888'
          alipay.account.should eql 'mahb45@example.com'
          alipay.key.should eql '2222'

          visit payments_path # 回显

          within '#payment_alipay' do
            page.should have_content('支付宝担保交易服务')
          end
        end

        it "should be destroy" do # 删除
          within '#payment_alipay' do
            page.execute_script("window.confirm = function(msg) { return true; }")
            find('.destroy').click
          end
          page.should have_content('删除成功!')
          within '#payment_alipay' do
            find('.payment_select').visible?.should be_true
            find('.activate_payment_provider').visible?.should be_false

            visit payments_path # 回显
            find('.payment_select').visible?.should be_true
            find('.activate_payment_provider').visible?.should be_false
          end
        end

      end

    end

  end

end
