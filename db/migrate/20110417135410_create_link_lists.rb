#encoding: utf-8
class CreateLinkLists < ActiveRecord::Migration
  def self.up
    create_table :link_lists do |t|
      t.string :title
      t.string :handle, comment: '用于模板中的Permalink/Handle'
      t.boolean :system_default, default: false, comment: '是否为系统默认链接列表'

      t.timestamps
    end
  end

  def self.down
    drop_table :link_lists
  end
end
