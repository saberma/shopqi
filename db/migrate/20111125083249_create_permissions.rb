#encoding: utf-8
class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references     :user
      t.integer        :resource_id,  comment: '关联资源'
    end
    add_index :permissions, [:user_id, :resource_id]
  end
end
