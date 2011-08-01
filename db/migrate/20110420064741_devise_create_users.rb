#encoding: utf-8
class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.string :name, comment:"姓名"
      t.string :phone, comment:"电话"
      t.text :bio,comment:"用户介绍"
      t.boolean :receive_announcements,comment:"是否接收网店邮件信息",default: true
      t.references :shop

      #增加用户权限
      t.boolean :admin, default: true

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable


      t.timestamps
    end

    add_index :users, :shop_id
    add_index :users, [:shop_id            , :email]        , :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
