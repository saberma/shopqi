class Payment < ActiveRecord::Base
  belongs_to :shop
  validates_presence_of :partner, :key, :service, if: Proc.new{|p| p.payment_type_id?}
  validates_presence_of :account, if: Proc.new{|p| p.is_alipay?} # 支付宝才需要account
  validates_presence_of :name, if: Proc.new{|p| !p.payment_type_id?}
  #default_scope order('created_at')

  before_validation do
    self.key = self.key_was if self.key_changed? and self.key.blank? # key为密码型，不回显，更新时可不需要输入
  end

  def payment_type
    KeyValues::PaymentType.find(self.payment_type_id)
  end

  begin 'online' # 支付宝、财付通等

    def self.alipay
      where(payment_type_id: 1).first
    end

    def self.tenpay
      where(payment_type_id: 2).first
    end

    def service_name # 支付接口类型
      if self.is_alipay?
        KeyValues::Payment::Alipay::Service.find_by_code(self.service).name
      elsif self.is_tenpay?
        KeyValues::Payment::Tenpay::Service.find_by_code(self.service).name
      end
    end

    def direct? # 即时到帐
      (self.is_alipay? and self.service == ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_DIRECT_PAY_BY_USER) or (self.is_tenpay? and self.service == 'direct')
    end

    def escrow? # 担保交易
      (self.is_alipay? and self.service == ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_PARTNER_TRADE_BY_BUYER) or (self.is_tenpay? and self.service == 'protect')
    end

    def dualfun? # 双功能收款
      (is_alipay? and self.service == ActiveMerchant::Billing::Integrations::Alipay::Helper::TRADE_CREATE_BY_BUYER)
    end

    def is_alipay?
      self.payment_type_id == 1
    end

    def is_tenpay?
      self.payment_type_id == 2
    end

  end

end
