#encoding: utf-8
class AddCartNote < ActiveRecord::Migration
  def change
    add_column :carts, :note, :string, comment: '备注'
  end
end
