class RenamePaymentPartnerToEmail < ActiveRecord::Migration

  def change # 402
    rename_column :payments, :partner, :email
  end

end
