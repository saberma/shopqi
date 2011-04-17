class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :title
      t.string :link_type
      t.string :subject_id
      t.string :subject_params
      t.string :subject

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
