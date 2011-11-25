require 'spec_helper'

describe Payment do

  let(:user) { Factory(:user_admin) }

  let(:shop) { user.shop }

  let(:payment_alipay) do # 支付方式:支付宝
    Factory :payment_alipay, shop: shop
  end

  context '#update' do

    it "should support empty key" do # 更新时不输入key
      payment_alipay.update_attributes key: '', account: 'admin@shopqi.com'
      payment_alipay.save.should be_true
      payment_alipay.account.should eql 'admin@shopqi.com'
      payment_alipay.key.should_not be_blank
    end

  end

end
