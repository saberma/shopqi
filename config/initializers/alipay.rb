AlipayConfig =  YAML::load_file(Rails.root.join('config/alipay.yml'))

ActiveMerchant::Billing::Integrations::Alipay::KEY =  AlipayConfig['key']

require 'active_merchant'
require 'active_merchant/billing/integrations/action_view_helper'

ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
