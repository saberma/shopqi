class CreateCustomCollections < ActiveRecord::Migration
  def self.up
    create_table :custom_collections do |t|
      t.string :title
      t.text :body_html

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_collections
  end
end
