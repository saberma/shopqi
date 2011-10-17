class CreateActiveAdminComments < ActiveRecord::Migration
  def self.up
    create_table :active_admin_comments do |t|
      t.references :resource, :polymorphic => true, :null => false
      t.string :author_type
      t.integer :author_id
      t.string :namespace
      t.text :body
      t.timestamps
    end
    add_index :active_admin_comments, [:resource_type, :resource_id]
    add_index :active_admin_comments, [:namespace]
    add_index :active_admin_comments, [:author_type, :author_id]
  end

  def self.down
    drop_table :active_admin_comments
  end
end
