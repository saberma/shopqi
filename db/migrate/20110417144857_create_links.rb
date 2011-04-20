# encoding: utf-8
class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :title
      t.string :link_type
      t.string :subject_id
      t.string :subject_params
      t.string :subject
      t.integer :link_list_id, :comment => '关联的链接列表id'

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
