class CreateAdminLinkLists < ActiveRecord::Migration
  def self.up
    create_table :admin_link_lists do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_link_lists
  end
end
