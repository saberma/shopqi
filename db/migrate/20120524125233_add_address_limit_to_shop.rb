class AddAddressLimitToShop < ActiveRecord::Migration
  def change # issues#450
    change_column :shops, :address, :string, limit: 64
  end
end
