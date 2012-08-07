class UpgradeDevise < ActiveRecord::Migration
  def change
    add_column :users      , :reset_password_sent_at, :datetime
    add_column :admin_users, :reset_password_sent_at, :datetime
    add_column :customers  , :reset_password_sent_at, :datetime
  end
end
