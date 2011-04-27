class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :product_image_uid
      t.references :product

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
