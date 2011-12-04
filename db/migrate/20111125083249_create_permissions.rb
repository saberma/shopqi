#encoding: utf-8
class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references     :user
      t.integer        :resource_id,  comment: '关联资源'
    end
    add_index :permissions, [:user_id, :resource_id]

    #为以前声场环境下准备权限
    if production?
      User.all.each do |u|
        u.prepare_resources if u.permissions.blank?
      end
    end
  end
end
