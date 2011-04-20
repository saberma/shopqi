class CreateLinkLists < ActiveRecord::Migration
  def self.up
    create_table :link_lists do |t|
      t.string :title
      #用于模板中的Permalink/Handle
      t.string :handle
      #是否为系统默认链接列表
      t.boolean :system_default, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :link_lists
  end
end
