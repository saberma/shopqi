# encoding: utf-8
class AddServiceToPayments < ActiveRecord::Migration

  def change
    add_column :payments, :service, :string, comment: '接口类型(即时到帐、担保交易、双功能收款)', limit: 32
  end

end
