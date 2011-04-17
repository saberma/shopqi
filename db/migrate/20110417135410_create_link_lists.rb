class CreateLinkLists < ActiveRecord::Migration
  def self.up
    create_table :link_lists do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :link_lists
  end
end
