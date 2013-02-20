#encoding: utf-8
class AddOrderTransactionStatus < ActiveRecord::Migration
  def up
    add_column :order_transactions, :status, :string, limit: 16, comment: '状态'
    add_column :order_transactions, :batch_no, :string, limit: 24, comment: '支付宝退款批次号'
    OrderTransaction.update_all status: :success
  end

  def down
    remove_column :order_transactions, :status
    remove_column :order_transactions, :batch_no
  end
end
